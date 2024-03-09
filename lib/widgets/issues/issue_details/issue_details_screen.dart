import 'package:flutter/material.dart';
import 'package:fto_app/model/issue.dart';

class IssueDetailsScreen extends StatelessWidget {
  const IssueDetailsScreen({super.key, required this.issueInfo});

  final Issue issueInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        // child: Text("Issue details"),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                        // color: Colors.deepOrange[100],
                        child: const Text(
                      "Issue ID:",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, fontFamily: 'Roboto'),
                      // style: Theme.of(context).textTheme.titleLarge,
                    )),
                    const SizedBox(width: 10),
                    Container(
                        // color: Colors.deepOrange[200],
                        child: Text(
                      "${issueInfo.id}",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, fontFamily: 'Roboto'),
                    )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Title:"),
                    const SizedBox(width: 5),
                    Text(issueInfo.title),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Reporter:"),
                    const SizedBox(width: 5),
                    Text(issueInfo.reporter.name),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Assignee:"),
                    const SizedBox(width: 5),
                    Text(issueInfo.assignee != null ? issueInfo.assignee!.name : ""),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Vehicle:"),
                    const SizedBox(width: 5),
                    Text(issueInfo.vehicle.registrationNumber),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Details:"),
                    const SizedBox(width: 5),
                    Text("${issueInfo.description}"),
                  ],
                ),
              ],
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ],
          ),
        ),
      ),
    );
  }
}
