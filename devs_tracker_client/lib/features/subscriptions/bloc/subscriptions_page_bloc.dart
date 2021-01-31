import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubscriptionsEvent {}

class ReloadEvent extends SubscriptionsEvent {}

class SubscriptionsState {
  final bool loaded;
  final bool failed;
  final SubscriptionsData data;

  SubscriptionsState.loading()
      : loaded = false,
        failed = false,
        data = null;

  SubscriptionsState.loaded(this.data)
      : loaded = true,
        failed = false;

  SubscriptionsState.failed()
      : loaded = true,
        failed = true,
        data = null;
}

class SubscriptionsData {
  final Subscriptions subscriptions;

  SubscriptionsData(this.subscriptions);
}

class SubscriptionsPageBloc
    extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final PurchaseRepository purchaseRepository;

  SubscriptionsPageBloc(this.purchaseRepository)
      : super(SubscriptionsState.loading()) {
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => reload());
  }

  @override
  Stream<SubscriptionsState> mapEventToState(SubscriptionsEvent event) async* {
    if (event is ReloadEvent) {
      yield SubscriptionsState.loading();
      yield await purchaseRepository.getSubscriptions().then((subscriptions) {
        print("Subscriptions loaded, $subscriptions");
        return SubscriptionsState.loaded(SubscriptionsData(subscriptions));
      }).catchError((error) {
        print("Error: " + error.toString());
        return SubscriptionsState.failed();
      });
    }
  }

  void reload() {
    add(ReloadEvent());
  }
}
