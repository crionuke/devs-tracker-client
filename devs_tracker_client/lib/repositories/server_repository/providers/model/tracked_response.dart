import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';

class TrackedResponse {
  final int count;
  final List<TrackedDeveloper> developers;

  TrackedResponse(this.count, this.developers);

  TrackedResponse.empty()
      : count = 0,
        developers = List();

  factory TrackedResponse.fromJson(Map<String, dynamic> json) {
    List<TrackedDeveloper> developers = (json["developers"] as List)
        .map((developer) => TrackedDeveloper.fromJson(developer))
        .toList();
    return TrackedResponse(json["count"], developers);
  }

  @override
  String toString() {
    return "count=$count, developer=$developers";
  }
}
