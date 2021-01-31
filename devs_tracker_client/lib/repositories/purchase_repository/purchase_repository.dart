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

  Future<Subscriptions> getSubscriptions() async {
    Offerings offerings = await Purchases.getOfferings();
    return Subscriptions(offerings.current);
  }

  void dispose() => controller.close();
}

class Subscriptions {

  final Subscription annual;
  final Subscription monthly;

  Subscriptions(Offering offering)
      :
        annual = Subscription(offering.annual.product),
        monthly = Subscription(offering.monthly.product);
}

class Subscription {

  final String title;
  final String description;
  final double price;
  final String priceString;
  final String currencyCode;

  Subscription(Product product)
      : title = product.title,
        description = product.description,
        price = product.price,
        priceString = product.priceString,
        currencyCode = product.currencyCode;
}
