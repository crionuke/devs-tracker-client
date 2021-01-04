import 'dart:async';

enum DbRepositoryStatus { loading, loaded }

class DbRepository {
  final _controller = StreamController<DbRepositoryStatus>();

  Stream<DbRepositoryStatus> get status async* {
    yield DbRepositoryStatus.loading;
    await Future<void>.delayed(const Duration(seconds: 1));
    yield DbRepositoryStatus.loaded;
  }

  void dispose() => _controller.close();
}