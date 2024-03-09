import 'package:flutter/material.dart';
import 'package:fto_app/model/vehicle.dart';
import 'package:fto_app/services/remote_service.dart';

class VehicleWidget extends StatelessWidget {
  const VehicleWidget({super.key, required this.onVehicleChanged});
  final Function onVehicleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Vehicle:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          VehicleDropdownMenu(
            onVehicleChanged: onVehicleChanged,
          ),
        ]);
  }
}

class VehicleDropdownMenu extends StatefulWidget {
  VehicleDropdownMenu({super.key, required this.onVehicleChanged});
  final TextEditingController controller = TextEditingController();

  final Function onVehicleChanged;

  @override
  State<StatefulWidget> createState() => VehicleDropdownMenuState();
}

class VehicleDropdownMenuState extends State<VehicleDropdownMenu> {
  final MockRemoteService _remoteService = MockRemoteService();
  List<DropdownMenuEntry<Vehicle>> vehiclesDropdownEntries = [];
  List<Vehicle>? vehicles;
  int? selectedVehicle;

  @override
  void initState() {
    getState();

    super.initState();
  }

  getState() async {
    _remoteService.getVehicles().then((readVehicles) {
      setState(() {
        vehicles = readVehicles ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      // enableFilter: true,
      controller: widget.controller,
      width: 200,
      initialSelection: selectedVehicle,
      dropdownMenuEntries: vehicles == null
          ? []
          : vehicles!.map<DropdownMenuEntry<int>>((Vehicle vehicle) {
              return DropdownMenuEntry<int>(
                value: vehicle.id,
                label: vehicle.registrationNumber,
                trailingIcon: vehicle.type == VehicleType.car
                    ? const Icon(Icons.agriculture_outlined)
                    : const Icon(Icons.rv_hookup),
              );
            }).toList(),
      onSelected: (selected) {
        setState(() {
          selectedVehicle = selected;
        });
        widget.onVehicleChanged(selected);
      },
      leadingIcon: const Icon(Icons.commute),
      // label: const Text("Vehicle"),
    );
  }
}
