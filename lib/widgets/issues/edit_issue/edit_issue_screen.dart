import 'package:flutter/material.dart';
import 'package:fto_app/model/issue.dart';
import 'package:fto_app/services/remote_service.dart';
import 'package:fto_app/widgets/issues/common/assignee_widget.dart';
import 'package:fto_app/widgets/issues/common/description_widget.dart';
import 'package:fto_app/widgets/issues/common/title_widget.dart';
import 'package:fto_app/widgets/issues/common/vehicle_widget.dart';

class EditIssueScreen extends StatefulWidget {
  const EditIssueScreen({super.key, required this.issue});
  final Issue issue;

  @override
  State<StatefulWidget> createState() => NewIssueRouteState();
}

class NewIssueRouteState extends State<EditIssueScreen> {
  // Maybe use state managment to update state of new issue from child widgets?
  // https://docs.flutter.dev/data-and-backend/state-mgmt/simple
  final MockRemoteService _remoteService = MockRemoteService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int? assigneeId;
  int? vehicleId;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.issue.title;
    if (widget.issue.description != null) descriptionController.text = widget.issue.description!;
    assigneeId = widget.issue.assignee?.id;
    vehicleId = widget.issue.vehicle.id;
  }

  void onAssigneeChanged(int id) {
    assigneeId = id;
  }

  void onVehicleChanged(int id) {
    vehicleId = id;
  }

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
        title: const Text('Edit issue'),
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
                AssigneeWidget(
                  onChanged: onAssigneeChanged,
                  initialId: widget.issue.assignee?.id,
                ),
                const SizedBox(height: 15),
                VehicleWidget(
                  onChanged: onVehicleChanged,
                  initialId: widget.issue.vehicle.id,
                ),
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
                        .updateIssueDetails(widget.issue.id,
                            newTitle: titleController.text,
                            newDescription: descriptionController.text,
                            newAssigneeID: assigneeId,
                            newVehicleID: vehicleId)
                        .whenComplete(() => Navigator.pop(context));
                  },
                  icon: const Icon(Icons.check)),
            ],
          ),
        ),
      ),
    );
  }
}
