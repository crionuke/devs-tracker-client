import 'package:devs_tracker_client/features/subscriptions/bloc/subscriptions_view_bloc.dart';
import 'package:devs_tracker_client/features/subscriptions/view/subscription_item.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SubscriptionsView extends StatelessWidget {
  final Subscriptions subscriptions;

  SubscriptionsView(this.subscriptions);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionsViewBloc>(
        create: (_) => SubscriptionsViewBloc(),
        child: BlocBuilder<SubscriptionsViewBloc, SubscriptionsViewState>(
            builder: (context, state) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Unlock up to 100 trackers\nby subscriptions:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubscriptionItem(
                  title: subscriptions.monthly.title,
                  totalPrice: subscriptions.monthly.priceString,
                  active: state.currentItemIndex == 0,
                  onTap: () =>
                      context.read<SubscriptionsViewBloc>().selectItem(0),
                ),
                SubscriptionItem(
                  title: subscriptions.annual.title,
                  totalPrice: subscriptions.annual.priceString,
                  active: state.currentItemIndex == 1,
                  onTap: () =>
                      context.read<SubscriptionsViewBloc>().selectItem(1),
                  description: subscriptions.annual.description,
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: FlatButton(
                    onPressed: () => print("ok"), child: Text("Continue")))
          ]);
        }));
  }
}
