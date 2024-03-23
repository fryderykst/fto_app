import 'package:flutter/material.dart';
import 'package:fto_app/model/user.dart';
import 'package:fto_app/services/remote_service.dart';

class AssigneeWidget extends StatelessWidget {
  const AssigneeWidget({super.key, required this.onChanged, this.initialId});

  final Function onChanged;
  final int? initialId;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Assignee:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          AssigneeDropdownMenu(
            onChanged: onChanged,
            initialId: initialId,
          ),
        ]);
  }
}

class AssigneeDropdownMenu extends StatefulWidget {
  const AssigneeDropdownMenu({super.key, required this.onChanged, this.initialId});

  final Function onChanged;
  final int? initialId;

  @override
  State<StatefulWidget> createState() => AssigneeDropdownMenuState();
}

class AssigneeDropdownMenuState extends State<AssigneeDropdownMenu> {
  final MockRemoteService _remoteService = MockRemoteService();
  List<DropdownMenuEntry<User>> usersDropdownEntries = [];
  List<User>? users;
  int? selectedPerson;

  @override
  void initState() {
    super.initState();

    _readUsers();
  }

  _readUsers() async {
    _remoteService.getUsers().then((readUsers) {
      setState(() {
        users = readUsers ?? [];
        selectedPerson = widget.initialId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      // enableFilter: true,
      // expandedInsets: const EdgeInsets.symmetric(horizontal: 0),
      width: 300,
      initialSelection: selectedPerson,
      dropdownMenuEntries: users == null
          ? []
          : users!.map<DropdownMenuEntry<int>>((User person) {
              return DropdownMenuEntry<int>(
                value: person.id,
                label: person.name,
              );
            }).toList(),
      onSelected: (selected) {
        setState(() {
          selectedPerson = selected;
        });
        widget.onChanged(selected);
      },
      leadingIcon: const Icon(Icons.person),
      // label: const Text("Assignee"),
    );
  }
}
