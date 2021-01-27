import 'dart:async';

import 'package:devs_tracker_client/repositories/server_repository/providers/developer_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/tracker_provider.dart';

enum ServerRepositoryStatus { loading, loaded }

class ServerRepository {
  final _controller = StreamController<ServerRepositoryStatus>();

  final DeveloperProvider developerProvider;
  final TrackerProvider trackerProvider;

  ServerRepository(String baseUrl) :
        developerProvider = DeveloperProvider(baseUrl + "/developers"),
        trackerProvider = TrackerProvider(baseUrl + "/trackers");


  Stream<ServerRepositoryStatus> get status async* {
    yield ServerRepositoryStatus.loading;
    yield ServerRepositoryStatus.loaded;
  }

  void dispose() => _controller.close();
}