import 'dart:async';

import 'package:purchases_flutter/purchases_flutter.dart';

enum PurchaseRepositoryStatus { loading, loaded }

enum ResultType {
  PURCHASED,
  CANCELLED,
  FAILED,
}

class PurchaseResult {
  ResultType resultType;
  PurchaserInfo purchaserInfo;

  PurchaseResult.finished(this.purchaserInfo)
      : resultType = ResultType.PURCHASED;

  PurchaseResult.cancelled()
      :resultType = ResultType.CANCELLED,
        purchaserInfo = null;

  PurchaseResult.failed()
      :resultType = ResultType.FAILED,
        purchaserInfo = null;
}

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

  Future<PurchaserInfo> getPurchaserInfo() async {
    return await Purchases.getPurchaserInfo();
  }

  Future<Offering> getCurrentOfferings() async =>
      (await Purchases.getOfferings()).current;

  Future<PurchaseResult> purchase(Package package) async {
    return await Purchases.purchasePackage(package)
        .then((purchaserInfo) => PurchaseResult.finished(purchaserInfo))
        .catchError((error) {
      print("Error: " + error.toString());
      if (PurchasesErrorHelper.getErrorCode(error) ==
          PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseResult.cancelled();
      } else {
        return PurchaseResult.failed();
      }
    });
  }

  void dispose() => controller.close();
}