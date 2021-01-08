import 'dart:async';

enum PurchaseRepositoryStatus { loading, loaded }

class PurchaseRepository {
  final _controller = StreamController<PurchaseRepositoryStatus>();

  Stream<PurchaseRepositoryStatus> get status async* {
    yield PurchaseRepositoryStatus.loading;
    await Future<void>.delayed(const Duration(seconds: 1));
    yield PurchaseRepositoryStatus.loaded;
  }

  void dispose() => _controller.close();
}