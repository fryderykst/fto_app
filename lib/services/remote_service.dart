import 'package:fto_app/model/issue.dart';
import 'package:fto_app/model/user.dart';
import 'package:fto_app/model/vehicle.dart';
import 'package:http/http.dart' as http;

class MockRemoteService extends RemoteService {
  MockRemoteService._privateConstructor() {
    _users = {
      0: User(id: 0, name: "Ala Kot"),
      1: User(id: 1, name: "Ela Pies"),
      2: User(id: 2, name: "Ola Mysz"),
    };

    _vehicles = {
      0: Vehicle(id: 0, type: VehicleType.car, registrationNumber: "DW C0000"),
      1: Vehicle(id: 1, type: VehicleType.car, registrationNumber: "DW C0001"),
      2: Vehicle(id: 2, type: VehicleType.trailer, registrationNumber: "DW T0001"),
      3: Vehicle(id: 3, type: VehicleType.trailer, registrationNumber: "DW T0002"),
    };

    _issues = [
      Issue(
          id: 0,
          reporter: _users[0]!,
          assignee: _users[1]!,
          vehicle: _vehicles[0]!,
          title: "Title 1",
          description: "Detailed description 1"),
      Issue(
          id: 1,
          reporter: _users[0]!,
          assignee: _users[1]!,
          vehicle: _vehicles[3]!,
          title: "Title 2",
          description: "Detailed description 2"),
      Issue(
          id: 2,
          reporter: _users[0]!,
          assignee: _users[1]!,
          vehicle: _vehicles[1]!,
          title: "Title 3",
          description: "Detailed description 3"),
      Issue(
          id: 3,
          reporter: _users[0]!,
          assignee: _users[1]!,
          vehicle: _vehicles[2]!,
          title: "Title 4",
          description: "Detailed description 4"),
    ];
  }

  static int _id = 3;
  late Map<int, User> _users;
  late List<Issue> _issues;
  late Map<int, Vehicle> _vehicles;
  static final MockRemoteService _instance = MockRemoteService._privateConstructor();

  factory MockRemoteService() {
    return _instance;
  }

  @override
  Future<List<Issue>?> getIssues() async {
    return Future<List<Issue>?>.delayed(const Duration(milliseconds: 400), () => _issues);
  }

  Future<bool> createIssue() async {
    int newId = ++_id;
    _issues.add(Issue(
        id: newId,
        reporter: _users[0]!,
        assignee: _users[1]!,
        vehicle: _vehicles[0]!,
        title: "Title ${newId + 1}",
        description: "Detailed description ${newId + 1}"));

    return Future<bool>.delayed(const Duration(milliseconds: 100), () => true);
  }

  Future<bool> createNewIssue(
    String newTitle,
    int newReporterID,
    int? newAssigneeID,
    int newVehicleID,
    String? newDescription,
  ) async {
    int newId = ++_id;
    _issues.add(Issue(
        id: newId,
        reporter: _users[newReporterID]!,
        assignee: _users[newAssigneeID]!,
        vehicle: _vehicles[newVehicleID]!,
        title: newTitle,
        description: newDescription));

    return Future<bool>.delayed(const Duration(milliseconds: 100), () => true);
  }

  Future<bool> removeIssue() async {
    if (_issues.isNotEmpty) _issues.removeLast();
    return Future<bool>.delayed(const Duration(milliseconds: 100), () => true);
  }

  Future<bool> removeIssueById(int id) async {
    int? pos;
    for (var i = 0; i < _issues.length; i++) {
      if (_issues[i].id == id) pos = i;
    }

    if (pos != null) _issues.removeAt(pos);

    return Future<bool>.delayed(const Duration(milliseconds: 100), () => true);
  }

  Future<List<User>?> getUsers() async {
    return Future<List<User>?>.delayed(const Duration(milliseconds: 200), () => _users.values.toList());
  }

  Future<List<Vehicle>?> getVehicles() async {
    return Future<List<Vehicle>?>.delayed(const Duration(milliseconds: 200), () => _vehicles.values.toList());
  }
}

class RemoteService {
  Future<List<Issue>?> getIssues() async {
    var client = http.Client();

    var uri = Uri.parse('https://jsonplaceholder.typicode.com/comments');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return issueFromJson(json);
    } else {
      throw ('error');
    }
  }
}
