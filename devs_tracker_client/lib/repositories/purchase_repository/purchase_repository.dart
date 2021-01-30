import 'dart:async';

import 'package:purchases_flutter/purchases_flutter.dart';

enum PurchaseRepositoryStatus { loading, loaded }

class PurchaseRepository {

  final StreamController controller;

  String _appUserID;

  PurchaseRepository()
      : controller = StreamController<PurchaseRepositoryStatus>();

  Stream<PurchaseRepositoryStatus> get status async* {
    yield PurchaseRepositoryStatus.loading;
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("FPWcTjJxfXPvrBNdFfkvYgCqBsggmJyG");
    _appUserID = await Purchases.appUserID;
    print("AppUserID=" + _appUserID);
    yield PurchaseRepositoryStatus.loaded;
  }

  String getUserID() => _appUserID;

  void dispose() => controller.close();
}