import 'package:flutter/material.dart';
import 'package:fto_app/services/remote_service.dart';
import 'package:fto_app/model/issue.dart';
import 'package:fto_app/widgets/issues/new_issue/new_issue_screen.dart';
import 'package:fto_app/widgets/issues/issues_list/issue_widget.dart';

class IssuesListScreen extends StatefulWidget {
  const IssuesListScreen({super.key});
  final String title = "My issues";

  @override
  State<IssuesListScreen> createState() => _IssuesListScreenState();
}

class _IssuesListScreenState extends State<IssuesListScreen> {
  final MockRemoteService _remoteService = MockRemoteService();
  List<Issue>? issues;

  @override
  void initState() {
    getState();

    super.initState();
  }

  getState() async {
    issues = await _remoteService.getIssues();
    setState(() {});
  }

  void addIssue() {
    _remoteService.createIssue().then((value) => getState());
  }

  Future<void> addNewIssue(BuildContext context) async {
    // https://docs.flutter.dev/cookbook/navigation/returning-data
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewIssueScreen()),
    );

    if (!context.mounted) return;

    if (result != null && result) getState();
  }

  void removeIssue(int id) {
    _remoteService.removeIssue(id).then((value) => getState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              // itemCount: issues!.length,
              itemCount: issues != null ? issues!.length : 0,
              itemBuilder: (context, index) {
                return IssueWidget(
                  issue: issues![index],
                  removeIssueFunc: removeIssue,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IconButton(onPressed: addIssue, icon: const Icon(Icons.add_box)),
              IconButton(
                  onPressed: () {
                    // print("Open details for issue ${issue.id}");
                    // Navigator.push(context, MaterialPageRoute(builder: ((context) => NewIssueRoute())));
                    addNewIssue(context);
                  },
                  icon: const Icon(Icons.add_box_outlined)),
              // IconButton(onPressed: removeIssue, icon: const Icon(Icons.remove))
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: _incrementCounter,
      //   // onPressed: null,
      //   onPressed: addIssue,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.centerDocked
    );
  }
}
