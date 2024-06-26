import 'package:flutter/material.dart';
import 'package:fto_app/model/vehicle.dart';
import 'package:fto_app/services/remote_service.dart';

class VehicleWidget extends StatelessWidget {
  const VehicleWidget({super.key, required this.onChanged, this.initialId});

  final Function onChanged;
  final int? initialId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Vehicle:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        VehicleDropdownMenu(
          onChanged: onChanged,
          initialId: initialId,
        ),
      ],
    );
  }
}

class VehicleDropdownMenu extends StatefulWidget {
  const VehicleDropdownMenu({super.key, required this.onChanged, this.initialId});

  final Function onChanged;
  final int? initialId;

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
    super.initState();

    _readVehicles();
  }

  _readVehicles() async {
    _remoteService.getVehicles().then((readVehicles) {
      setState(() {
        vehicles = readVehicles ?? [];
        selectedVehicle = widget.initialId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      // enableFilter: true,
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
        widget.onChanged(selected);
      },
      leadingIcon: const Icon(Icons.commute),
      // label: const Text("Vehicle"),
      errorText: selectedVehicle != null ? null : 'Vehicle can\'t be empty!',
    );
  }
}
