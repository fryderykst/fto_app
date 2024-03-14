import 'package:flutter/material.dart';
import 'package:fto_app/common/string_extension.dart';
import 'package:fto_app/model/issue.dart';
import 'package:fto_app/services/remote_service.dart';

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

class _IssueDetailsScafoldState extends State<_IssueDetailsScafold> {
  final MockRemoteService _remoteService = MockRemoteService();
  late Issue issueInfo = widget.issue;

  _IssueDetailsScafoldState();

  @override
  void initState() {
    super.initState();
  }

  void getIssue() {
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
                onPressed: () {},
                icon: const Icon(Icons.edit),
                tooltip: "Edit",
              ),
              IconButton(
                onPressed: () {
                  MockRemoteService().updateIssue(issueInfo.id, newStatus: IssueStatus.done);
                  getIssue();
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
