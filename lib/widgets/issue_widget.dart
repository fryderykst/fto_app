import 'package:flutter/material.dart';
import 'package:fto_app/model/issue.dart';
import 'package:fto_app/widgets/issue_screen.dart';

class IssueWidget extends StatelessWidget {
  const IssueWidget({super.key, required this.issue, required this.removeIssueFunc});

  final Issue issue;

  final Function removeIssueFunc;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.red.shade100,
      child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                // constraints: const BoxConstraints(maxWidth: 200),
                child: ListTile(
                  onTap: () {
                    // print("Open details for issue ${issue.id}");
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => IssueScreen(issueInfo: issue))));
                  },
                  leading: Text(issue.id.toString()),
                  title: Text(issue.title),
                  subtitle: Text(issue.description.toString()),
                ),
              ),
              // const Text(("Details"))
              IconButton(onPressed: () => removeIssueFunc(issue.id), icon: const Icon(Icons.remove))
            ],
          )),
    );
  }
}
