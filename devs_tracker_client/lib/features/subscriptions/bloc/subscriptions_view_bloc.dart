import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubscriptionsViewEvent {}

class SubscriptionSelected extends SubscriptionsViewEvent {
  final int itemIndex;

  SubscriptionSelected(this.itemIndex);
}

class SubscriptionsViewState {
  final int currentItemIndex;

  SubscriptionsViewState(this.currentItemIndex);
}

class SubscriptionsViewBloc extends Bloc<SubscriptionsViewEvent, SubscriptionsViewState> {
  SubscriptionsViewBloc() : super(SubscriptionsViewState(1));

  @override
  Stream<SubscriptionsViewState> mapEventToState(SubscriptionsViewEvent event) async* {
    if (event is SubscriptionSelected) {
      yield SubscriptionsViewState(event.itemIndex);
    }
  }

  void selectItem(int itemIndex) {
    add(SubscriptionSelected(itemIndex));
  }
}
