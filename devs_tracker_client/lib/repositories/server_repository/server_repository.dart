import 'dart:async';

import "developers_provider/developers_provider.dart";

enum ServerRepositoryStatus { loading, loaded }

class ServerRepository {
  final _controller = StreamController<ServerRepositoryStatus>();

  final DevelopersProvider developersProvider;

  ServerRepository(String baseUrl) :
        developersProvider = DevelopersProvider(baseUrl + "/developers");

  Stream<ServerRepositoryStatus> get status async* {
    yield ServerRepositoryStatus.loading;
    await Future<void>.delayed(const Duration(seconds: 1));
    yield ServerRepositoryStatus.loaded;
  }

  void dispose() => _controller.close();
}