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

    _issues = {
      0: Issue(
        id: 0,
        reporter: _users[0]!,
        assignee: _users[1]!,
        vehicle: _vehicles[0]!,
        title: "Title 1",
        description: "Detailed description 1",
        status: IssueStatus.done,
      ),
      1: Issue(
        id: 1,
        reporter: _users[0]!,
        assignee: _users[1]!,
        vehicle: _vehicles[3]!,
        title:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in felis malesuada, lacinia ipsum eu, rhoncus justo. Nunc dictum, lectus ut luctus lacinia, orci felis congue purus, id lacinia libero ante sit amet ipsum. Pellentesque consectetur, diam at finibus luctus, sapien risus lobortis tellus, sed ultrices tellus sapien at ipsum. Morbi a imperdiet sem, fermentum ullamcorper risus. Ut dignissim dignissim magna, ut porta dolor pellentesque vitae. Fusce porta quam ut imperdiet posuere. Aenean nec purus id lectus laoreet imperdiet maximus sed nunc. Etiam suscipit vehicula orci, in iaculis eros molestie ut. Nunc finibus nec nibh id bibendum. Sed vel tincidunt urna, id sodales metus. Vestibulum rutrum laoreet tortor, sit amet rhoncus dui. Curabitur lacinia ex cursus, euismod libero in, laoreet neque.",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in felis malesuada, lacinia ipsum eu, rhoncus justo. Nunc dictum, lectus ut luctus lacinia, orci felis congue purus, id lacinia libero ante sit amet ipsum. Pellentesque consectetur, diam at finibus luctus, sapien risus lobortis tellus, sed ultrices tellus sapien at ipsum. Morbi a imperdiet sem, fermentum ullamcorper risus. Ut dignissim dignissim magna, ut porta dolor pellentesque vitae. Fusce porta quam ut imperdiet posuere. Aenean nec purus id lectus laoreet imperdiet maximus sed nunc. Etiam suscipit vehicula orci, in iaculis eros molestie ut. Nunc finibus nec nibh id bibendum. Sed vel tincidunt urna, id sodales metus. Vestibulum rutrum laoreet tortor, sit amet rhoncus dui. Curabitur lacinia ex cursus, euismod libero in, laoreet neque. Duis lobortis ultrices orci, sed blandit dui vulputate vel. Ut sit amet arcu eu ex posuere dictum at et quam. Fusce iaculis tincidunt lectus, vitae pellentesque augue sollicitudin in. In hac habitasse platea dictumst. Donec tincidunt mauris dolor, ac vestibulum nisl accumsan luctus. Sed mauris justo, luctus sit amet arcu et, facilisis bibendum est. Etiam ornare sed dui pretium efficitur. Sed congue tincidunt neque, ac sollicitudin purus pulvinar ut. In suscipit accumsan elit, ac ultricies nisi fermentum ac. Donec commodo enim quis dolor porttitor lobortis. Aliquam eget pulvinar justo. Proin ultricies, magna in placerat aliquet, nibh dolor bibendum augue, quis convallis neque est eu velit. Quisque nunc nibh, accumsan sit amet posuere sed, vulputate eget urna. Nulla quis viverra tellus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Vivamus in urna nisi. Pellentesque enim elit, mollis eu ante ut, auctor scelerisque leo. Donec suscipit felis sit amet arcu aliquam auctor. Nam in leo luctus, sagittis turpis vel, congue sapien. Etiam non diam sagittis arcu accumsan rhoncus. Nam in commodo est, sed porttitor ipsum. Phasellus ac mollis dolor. Fusce egestas ipsum a pellentesque viverra. Sed porttitor eleifend ex vitae molestie. Aenean in pretium magna. Ut auctor, turpis id pharetra porta, orci leo porttitor sem, nec auctor nisi risus id quam.",
        status: IssueStatus.done,
      ),
      2: Issue(
        id: 2,
        reporter: _users[0]!,
        assignee: _users[1]!,
        vehicle: _vehicles[1]!,
        title: "Title 3",
        description: "Detailed description 3",
      ),
      3: Issue(
        id: 3,
        reporter: _users[0]!,
        assignee: _users[1]!,
        vehicle: _vehicles[2]!,
        title: "Title 4",
        description: "Detailed description 4",
      ),
    };
  }

  static int _id = 3;
  late Map<int, User> _users;
  late Map<int, Issue> _issues;
  late Map<int, Vehicle> _vehicles;
  static final MockRemoteService _instance = MockRemoteService._privateConstructor();

  factory MockRemoteService() {
    return _instance;
  }

  @override
  Future<List<Issue>?> getIssues() async {
    return Future<List<Issue>?>.delayed(const Duration(milliseconds: 400), () => _issues.values.toList());
  }

  Future<Issue> getIssue(int id) async {
    // return Future<Issue>.delayed(
    //     const Duration(milliseconds: 400), () => Future<Issue>.error("Error loading issue $id"));
    if (_issues.containsKey(id)) {
      return Future<Issue>.delayed(const Duration(milliseconds: 400), () => _issues[id]!);
    } else {
      return Future<Issue>.delayed(
          const Duration(milliseconds: 400), () => Future<Issue>.error("Error loading issue $id"));
    }
  }

  Future<bool> createIssue() async {
    int newId = ++_id;
    _issues[newId] = Issue(
        id: newId,
        reporter: _users[0]!,
        assignee: _users[1]!,
        vehicle: _vehicles[0]!,
        title: "Title ${newId + 1}",
        description: "Detailed description ${newId + 1}");

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
    _issues[newId] = Issue(
        id: newId,
        reporter: _users[newReporterID]!,
        assignee: _users[newAssigneeID]!,
        vehicle: _vehicles[newVehicleID]!,
        title: newTitle,
        description: newDescription);

    return Future<bool>.delayed(const Duration(milliseconds: 100), () => true);
  }

  Future<bool> updateIssue(
    int id, {
    String? newTitle,
    // int? newReporterID,
    int? newAssigneeID,
    int? newVehicleID,
    String? newDescription,
    IssueStatus? newStatus,
  }) async {
    if (!_issues.containsKey(id)) return Future<bool>.delayed(const Duration(milliseconds: 50), () => false);

    if (newTitle != null) _issues[id]!.title = newTitle;
    // if (newReporterID != null && _users.containsKey(newReporterID)) _issues[id]!.reporter = _users[newReporterID];
    if (newAssigneeID != null && _users.containsKey(newAssigneeID)) _issues[id]!.assignee = _users[newAssigneeID];
    if (newVehicleID != null && _users.containsKey(newVehicleID)) _issues[id]!.vehicle = _vehicles[newVehicleID]!;
    if (newDescription != null) _issues[id]!.description = newDescription;
    if (newStatus != null) _issues[id]!.status = newStatus;

    return Future<bool>.delayed(const Duration(milliseconds: 100), () => true);
  }

  Future<bool> removeIssue(int id) async {
    _issues.remove(id);

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
