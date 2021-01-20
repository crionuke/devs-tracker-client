import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';

class DeveloperAppsResponse {
  final int count;
  final List<DeveloperApp> apps;

  DeveloperAppsResponse(this.count, this.apps);

  DeveloperAppsResponse.empty()
      : count = 0,
        apps = List();

  factory DeveloperAppsResponse.fromJson(Map<String, dynamic> json) {
    List<DeveloperApp> apps = (json["apps"] as List)
        .map((app) => DeveloperApp.fromJson(app))
        .toList();
    return DeveloperAppsResponse(json["count"], apps);
  }

  @override
  String toString() {
    return "count=$count, apps=$apps";
  }
}
