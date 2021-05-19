import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionsEvent {}

class ReloadEvent extends SubscriptionsEvent {
  final String snackText;

  ReloadEvent({this.snackText});
}

class PurchaseEvent extends SubscriptionsEvent {
  final Package package;

  PurchaseEvent(this.package);
}

enum SubscriptionsStatus {
  LOADING,
  OFFERING,
  ACTIVE,
  FAILED,
}

class SubscriptionsState {
  final SubscriptionsStatus status;
  final Offering offering;
  final EntitlementInfo entitlementInfo;
  final String snackText;

  SubscriptionsState.loading()
      : status = SubscriptionsStatus.LOADING,
        offering = null,
        entitlementInfo = null,
        snackText = null;

  SubscriptionsState.offering({this.offering, this.snackText})
      : status = SubscriptionsStatus.OFFERING,
        entitlementInfo = null;

  SubscriptionsState.active({this.entitlementInfo, this.snackText})
      : status = SubscriptionsStatus.ACTIVE,
        offering = null;

  SubscriptionsState.failed({this.snackText})
      : status = SubscriptionsStatus.FAILED,
        offering = null,
        entitlementInfo = null;
}

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final PurchaseRepository purchaseRepository;

  SubscriptionsBloc(this.purchaseRepository)
      : super(SubscriptionsState.loading()) {
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => reload());
  }

  @override
  Stream<SubscriptionsState> mapEventToState(SubscriptionsEvent event) async* {
    // Reload
    if (event is ReloadEvent) {
      yield SubscriptionsState.loading();
      yield await purchaseRepository
          .getPurchaserInfo()
          .then((purchaserInfo) async {
        if (purchaserInfo.entitlements.all["Access"] != null &&
            purchaserInfo.entitlements.all["Access"].isActive) {
          print("Found active entitlements, $purchaserInfo");
          return SubscriptionsState.active(
              entitlementInfo: purchaserInfo.entitlements.all["Access"],
              snackText: event.snackText);
        } else {
          return await purchaseRepository
              .getCurrentOfferings()
              .then((offering) {
            print("Offering loaded, $offering");
            return SubscriptionsState.offering(
                offering: offering, snackText: event.snackText);
          }).catchError((error) {
            print("Error: " + error.toString());
            return SubscriptionsState.failed(snackText: event.snackText);
          });
        }
      }).catchError((error) {
        print("Error: " + error.toString());
        return SubscriptionsState.failed(snackText: event.snackText);
      });
      // Purchase
    } else if (event is PurchaseEvent) {
      yield SubscriptionsState.loading();
      purchaseRepository.purchase(event.package).then((purchaseResult) {
        if (purchaseResult.resultType == ResultType.PURCHASED) {
          print("${event.package.identifier} purchased");
          reload(snackText: "Activated!");
        } else if (purchaseResult.resultType == ResultType.CANCELLED) {
          print("${event.package.identifier} cancelled");
          reload(snackText: "Cancelled!");
        } else if (purchaseResult.resultType == ResultType.FAILED) {
          print("${event.package.identifier} failed");
          reload(snackText: "Sorry, something failed, try again!");
        } else {
          reload(snackText: "Unknown error, try again!");
        }
      }).catchError((error) {
        print("Error: " + error.toString());
        reload(snackText: "Unknown error, try again!");
      });
    }
  }

  void reload({String snackText}) {
    add(ReloadEvent(snackText: snackText));
  }

  void purchase(Package package) {
    add(PurchaseEvent(package));
  }
}
