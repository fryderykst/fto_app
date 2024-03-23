import 'package:flutter/material.dart';
import 'package:fto_app/services/remote_service.dart';
import 'package:fto_app/widgets/issues/common/assignee_widget.dart';
import 'package:fto_app/widgets/issues/common/description_widget.dart';
import 'package:fto_app/widgets/issues/common/title_widget.dart';
import 'package:fto_app/widgets/issues/common/vehicle_widget.dart';

class NewIssueScreen extends StatefulWidget {
  const NewIssueScreen({super.key});

  @override
  State<StatefulWidget> createState() => NewIssueRouteState();
}

class NewIssueRouteState extends State<NewIssueScreen> {
  // Maybe use state managment to update state of new issue from child widgets?
  // https://docs.flutter.dev/data-and-backend/state-mgmt/simple
  final MockRemoteService _remoteService = MockRemoteService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _assigneeId;
  int? _vehicleId;
  bool _confirmButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _titleController.addListener(_refreshConfirmButtonState);
    _descriptionController.addListener(_refreshConfirmButtonState);

    _refreshConfirmButtonState();
  }

  void _onAssigneeChanged(int id) {
    if (_assigneeId != id) {
      setState(() {
        _assigneeId = id;
      });
    }

    _refreshConfirmButtonState();
  }

  void _onVehicleChanged(int id) {
    if (_vehicleId != id) {
      setState(() {
        _vehicleId = id;
      });
    }

    _refreshConfirmButtonState();
  }

  _refreshConfirmButtonState() {
    bool newState = _titleController.text.isNotEmpty && _vehicleId != null;
    if (_confirmButtonEnabled != newState) {
      setState(() {
        _confirmButtonEnabled = newState;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                TitleWidget(textController: _titleController),
                const SizedBox(height: 15),
                AssigneeWidget(
                  onChanged: _onAssigneeChanged,
                ),
                const SizedBox(height: 15),
                VehicleWidget(
                  onChanged: _onVehicleChanged,
                ),
                const SizedBox(height: 15),
                DescriptionWidget(textController: _descriptionController),
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
                onPressed: _confirmButtonEnabled == false
                    ? null
                    : () {
                        // https://docs.flutter.dev/cookbook/forms/retrieve-input
                        // Navigator.pop(context, "Nowy tytuł");

                        // Navigator.maybePop(context); //Default behaviour when push back button on AppBar
                        _remoteService
                            .createNewIssue(
                                _titleController.text, 0, _assigneeId, _vehicleId!, _descriptionController.text)
                            .then((result) {
                          Navigator.pop(context, result);
                        });
                      },
                icon: const Icon(Icons.check),
                tooltip: _confirmButtonEnabled ? "Create issue" : "Enter all required values!",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
