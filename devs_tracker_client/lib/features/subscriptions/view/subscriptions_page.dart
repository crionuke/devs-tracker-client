import 'package:devs_tracker_client/features/subscriptions/bloc/subscriptions_page_bloc.dart';
import 'package:devs_tracker_client/features/subscriptions/view/subscriptions_view.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/widgets/error_view.dart';
import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionsPage extends StatelessWidget {
  static Route route(PurchaseRepository purchaseRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider<SubscriptionsPageBloc>(
            create: (_) => SubscriptionsPageBloc(purchaseRepository),
            child: SubscriptionsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Subscriptions")),
      body: Container(child: LiquidView(
        child: BlocBuilder<SubscriptionsPageBloc, SubscriptionsState>(
            builder: (context, state) {
          if (state.loaded) {
            if (state.failed) {
              return ErrorView(
                  () => context.read<SubscriptionsPageBloc>().reload());
            } else {
              return SubscriptionsView(state.data.subscriptions);
            }
          } else {
            return LoadingView();
          }
        }),
      )),
    );
  }
}
