import 'package:flutter/material.dart';
import 'package:fto_app/model/user.dart';
import 'package:fto_app/services/remote_service.dart';

class AssigneeWidget extends StatelessWidget {
  const AssigneeWidget({super.key, required this.onAssigneeChanged});
  final Function onAssigneeChanged;

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
            onAssigneeChanged: onAssigneeChanged,
          ),
        ]);
  }
}

class AssigneeDropdownMenu extends StatefulWidget {
  AssigneeDropdownMenu({super.key, required this.onAssigneeChanged});
  final TextEditingController controller = TextEditingController();

  final Function onAssigneeChanged;

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
    getState();

    super.initState();
  }

  getState() async {
    _remoteService.getUsers().then((readUsers) {
      setState(() {
        users = readUsers ?? [];
      });

      // usersDropdownEntries = users!.map<DropdownMenuEntry<Person>>((Person person) {
      //   return DropdownMenuEntry<Person>(value: person, label: person.name);
      // }).toList();
    });
    // usersDropdownEntries = users!.map<DropdownMenuEntry<Person>>((Person person) {
    //   return DropdownMenuEntry<Person>(value: person, label: person.name);
    // }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // return DropdownButton<Person>(
    //   value: selectedPerson,
    //   items: users == null
    //       ? []
    //       : users!.map<DropdownMenuItem<Person>>((Person person) {
    //           return DropdownMenuItem<Person>(value: person, child: Text(person.name));
    //         }).toList(),
    //   onChanged: (selected) {
    //     setState(() {
    //       selectedPerson = selected;
    //     });
    //   },
    // );
    return DropdownMenu<int>(
      // enableFilter: true,
      controller: widget.controller,
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
        widget.onAssigneeChanged(selected);
      },
      leadingIcon: const Icon(Icons.person),
      // label: const Text("Assignee"),
    );
  }
}
