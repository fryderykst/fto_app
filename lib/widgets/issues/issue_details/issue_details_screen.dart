import 'package:flutter/material.dart';
import 'package:fto_app/common/string_extension.dart';
import 'package:fto_app/model/issue.dart';
import 'package:fto_app/services/remote_service.dart';
import 'package:fto_app/widgets/issues/edit_issue/edit_issue_screen.dart';
import 'package:fto_app/widgets/issues/issues_list/issues_list_screen.dart';

class IssueDetailsScreen extends StatefulWidget {
  const IssueDetailsScreen({super.key, required this.issueId});
  final int issueId;

  @override
  State<StatefulWidget> createState() => IssueDetailsScreenState();
}

class IssueDetailsScreenState extends State<IssueDetailsScreen> {
  final MockRemoteService _remoteService = MockRemoteService();
  late Issue issueInfo;
  late final Future<Issue> _getIssueFutur = _remoteService.getIssue(widget.issueId);

  void getIssue() {
    _remoteService.getIssue(widget.issueId).then((value) {
      setState(() {
        issueInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Issue>(
      future: _getIssueFutur,
      builder: ((context, snapshot) {
        Widget child = _LoadingIssueInProgressScafold();

        if (snapshot.hasData) {
          issueInfo = snapshot.data!;
          child = _IssueDetailsScafold(issue: issueInfo);
        } else if (snapshot.hasError) {
          child = _ErrorLoadingIssueScafold(errorMessage: snapshot.error.toString());
        }

        return child;
      }),
    );
  }
}

class _IssueDetailsScafold extends StatefulWidget {
  const _IssueDetailsScafold({required this.issue});
  final Issue issue;

  @override
  State<StatefulWidget> createState() => _IssueDetailsScafoldState();
}

enum _IssueDetailMenuEntry {
  edit('Edit', Icon(Icons.edit)),
  close('Close issue', Icon(Icons.done)),
  delete('Remove issue', Icon(Icons.delete));

  const _IssueDetailMenuEntry(this.label, this.icon);
  final String label;
  final Icon icon;
}

class _IssueDetailsScafoldState extends State<_IssueDetailsScafold> {
  final MockRemoteService _remoteService = MockRemoteService();
  late Issue issueInfo = widget.issue;

  _IssueDetailsScafoldState();

  @override
  void initState() {
    super.initState();
  }

  void _readIssue() {
    _remoteService.getIssue(widget.issue.id).then((value) {
      setState(() {
        issueInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          issueInfo.title,
          // style: Theme.of(context).primaryTextTheme.headlineMedium,
          // overflow: TextOverflow.ellipsis,
        ),
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                leadingIcon: _IssueDetailMenuEntry.edit.icon,
                child: Text(_IssueDetailMenuEntry.edit.label),
                onPressed: () => _onEditClicked(context),
              ),
              MenuItemButton(
                leadingIcon: _IssueDetailMenuEntry.close.icon,
                child: Text(_IssueDetailMenuEntry.close.label),
                onPressed: () => _showCloseIssueDialog(context),
              ),
              MenuItemButton(
                leadingIcon: _IssueDetailMenuEntry.delete.icon,
                child: Text(_IssueDetailMenuEntry.delete.label),
                onPressed: () => _showDeleteIssueDialog(context),
              ),
            ],
            builder: (context, controller, child) {
              return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const DrawerButtonIcon());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: _IssueDetailsBody(issue: widget.issue),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _onEditClicked(context),
                icon: const Icon(Icons.edit),
                tooltip: "Edit",
              ),
              IconButton(
                onPressed: () {
                  MockRemoteService().updateIssueDetails(issueInfo.id, newStatus: IssueStatus.done);
                  _readIssue();
                },
                icon: const Icon(Icons.done),
                tooltip: "Set as done",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCloseIssueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Are you sure you want to close the issue?"),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Yes, close the issue"),
                    onPressed: () {
                      MockRemoteService()
                          .updateIssueDetails(issueInfo.id, newStatus: IssueStatus.done)
                          .then((value) => _readIssue())
                          .whenComplete(() => Navigator.of(context).pop());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteIssueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Are you sure you want to delete the issue?"),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Yes, delete the issue"),
                    onPressed: () {
                      MockRemoteService().removeIssue(issueInfo.id).whenComplete(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IssuesListScreen(),
                            ),
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEditClicked(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditIssueScreen(issue: issueInfo)),
    ).whenComplete(() {
      _readIssue();
    });
  }
}

class _IssueDetailsBody extends StatelessWidget {
  const _IssueDetailsBody({required this.issue});
  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: Text("Issue details"),
      child: SelectionArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Row(
                //   children: [
                //     Text(
                //       "Issue ID:",
                //       // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, fontFamily: 'Roboto'),
                //       style: Theme.of(context).primaryTextTheme.bodyMedium,
                //     ),
                //     const SizedBox(width: 10),
                //     Text(
                //       "${issueInfo.id}",
                //       // style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, fontFamily: 'Roboto'),
                //       style: Theme.of(context).primaryTextTheme.bodyMedium,
                //     ),
                //   ],
                // ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        issue.title,
                        style: Theme.of(context).primaryTextTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    issue.status == IssueStatus.open
                        ? Icon(
                            size: 15,
                            // Icons.radio_button_unchecked,
                            Icons.pending,
                            color: Colors.yellow.shade800,
                          )
                        : Icon(
                            size: 15,
                            Icons.check_circle,
                            color: Colors.green.shade800,
                          ),
                    Text(
                      issue.status.toString().split('.').last.toCapitalized(),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text("Reporter:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(issue.reporter.name),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text("Assignee:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(issue.assignee != null ? issue.assignee!.name : ""),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text("Vehicle:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(issue.vehicle.registrationNumber),
                  ],
                ),
                const Divider(
                  height: 20,
                ),
                Row(
                  children: [
                    // const Text("Details:"),
                    // const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "${issue.description}",
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class _ErrorLoadingIssueScafold extends StatelessWidget {
  const _ErrorLoadingIssueScafold({this.errorMessage});
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Issue details"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(errorMessage == null ? 'Error loading issue' : errorMessage!),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
        ),
      ),
    );
  }
}

class _LoadingIssueInProgressScafold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Issue details"),
      ),
      body: const Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Loading issue...'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
        ),
      ),
    );
  }
}
