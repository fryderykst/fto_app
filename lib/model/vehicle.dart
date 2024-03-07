import 'dart:convert';

List<Vehicle> vehicleFromJson(String str) => List<Vehicle>.from(json.decode(str).map((x) => Vehicle.fromJson(x)));

String vehicleToJson(List<Vehicle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

enum VehicleType { car, trailer }

class Vehicle {
  int id;
  String registrationNumber;
  VehicleType type;

  Vehicle({required this.id, required this.registrationNumber, required this.type});

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Vehicle && other.id == id;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        registrationNumber: json["registration_number"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registration_number": registrationNumber,
        "type": type,
      };
}
