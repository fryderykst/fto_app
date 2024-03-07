import 'package:flutter/material.dart';
import 'package:fto_app/services/remote_service.dart';
import 'package:fto_app/widgets/new_issue/assignee_widget.dart';
import 'package:fto_app/widgets/new_issue/description_widget.dart';
import 'package:fto_app/widgets/new_issue/title_widget.dart';
import 'package:fto_app/widgets/new_issue/vehicle_widget.dart';

class NewIssueScreen extends StatefulWidget {
  const NewIssueScreen({super.key});

  @override
  State<StatefulWidget> createState() => NewIssueRouteState();
}

class NewIssueRouteState extends State<NewIssueScreen> {
  // Maybe use state managment to update state of new issue from child widgets?
  // https://docs.flutter.dev/data-and-backend/state-mgmt/simple
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final MockRemoteService _remoteService = MockRemoteService();
  int? assigneeId;
  int? vehicleId;

  @override
  void initState() {
    super.initState();
    getState();
  }

  void onAssigneeChanged(int id) {
    assigneeId = id;
  }

  void onVehicleChanged(int id) {
    vehicleId = id;
  }

  getState() async {}

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new issue'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleWidget(textController: titleController),
                const SizedBox(height: 15),
                AssigneeWidget(onAssigneeChanged: onAssigneeChanged),
                const SizedBox(height: 15),
                VehicleWidget(onVehicleChanged: onVehicleChanged),
                const SizedBox(height: 15),
                DescriptionWidget(textController: descriptionController),
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
                    // https://docs.flutter.dev/cookbook/forms/retrieve-input
                    // Navigator.pop(context, "Nowy tytuł");

                    // Navigator.maybePop(context); //Default behaviour when push back button on AppBar
                    _remoteService
                        .createNewIssue(titleController.text, 0, assigneeId, vehicleId!, descriptionController.text)
                        .then((result) {
                      Navigator.pop(context, result);
                    });
                  },
                  icon: const Icon(Icons.check)),
            ],
          ),
        ),
      ),
    );
  }
}
