import 'dart:convert';

import 'package:fto_app/model/user.dart';
import 'package:fto_app/model/vehicle.dart';

List<Issue> issueFromJson(String str) => List<Issue>.from(json.decode(str).map((x) => Issue.fromJson(x)));

String isseToJson(List<Issue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

enum IssueStatus { open, done }

class Issue {
  int id;
  User reporter;
  User? assignee;
  Vehicle vehicle;
  String title;
  String? description;
  IssueStatus status;

  Issue({
    required this.id,
    required this.reporter,
    this.assignee,
    required this.vehicle,
    required this.title,
    this.description,
    this.status = IssueStatus.open,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Issue && other.id == id;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        id: json["id"],
        reporter: json["reporter"],
        assignee: json["assignee"],
        vehicle: json["vehicle"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reporter": reporter,
        "assignee": assignee,
        "vehicle": vehicle,
        "title": title,
        "description": description,
        "status": status,
      };
}
