import 'dart:async';

import 'package:devs_tracker_client/repositories/server_repository/providers/app_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/developer_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/tracker_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/user_provider.dart';

enum ServerRepositoryStatus { loading, loaded }

class ServerRepository {
  final StreamController controller;
  final DeveloperProvider developerProvider;
  final TrackerProvider trackerProvider;
  final AppProvider appProvider;
  final UserProvider userProvider;

  ServerRepository(String baseUrl)
      : controller = StreamController<ServerRepositoryStatus>(),
        developerProvider = DeveloperProvider(baseUrl + "/developers"),
        trackerProvider = TrackerProvider(baseUrl + "/trackers"),
        appProvider = AppProvider(baseUrl + "/apps"),
        userProvider = UserProvider(baseUrl + "/users");

  Stream<ServerRepositoryStatus> get status async* {
    yield ServerRepositoryStatus.loading;
    yield ServerRepositoryStatus.loaded;
  }

  void dispose() => controller.close();
}
