import 'package:flutter/material.dart';
import 'package:fto_app/common/string_extension.dart';
import 'package:fto_app/model/issue.dart';

class IssueDetailsScreen extends StatelessWidget {
  const IssueDetailsScreen({super.key, required this.issueInfo});

  final Issue issueInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          issueInfo.title,
          style: Theme.of(context).primaryTextTheme.headlineMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                            issueInfo.title,
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
                        issueInfo.status == IssueStatus.open
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
                          issueInfo.status.toString().split('.').last.toCapitalized(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Reporter:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        Text(issueInfo.reporter.name),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Assignee:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        Text(issueInfo.assignee != null ? issueInfo.assignee!.name : ""),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Vehicle:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        Text(issueInfo.vehicle.registrationNumber),
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
                            "${issueInfo.description}",
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                  },
                  icon: const Icon(Icons.edit)),
            ],
          ),
        ),
      ),
    );
  }
}
