import 'package:devs_tracker_client/features/subscriptions/bloc/subscriptions_bloc.dart';
import 'package:devs_tracker_client/features/subscriptions/view/entitlement_view.dart';
import 'package:devs_tracker_client/features/subscriptions/view/offering_view.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/widgets/error_view.dart';
import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionsPage extends StatelessWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static Route route(PurchaseRepository purchaseRepository) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            BlocProvider<SubscriptionsBloc>(
                create: (_) => SubscriptionsBloc(purchaseRepository),
                child: SubscriptionsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("Subscriptions")),
      body: Container(child: LiquidView(
        child: BlocListener<SubscriptionsBloc, SubscriptionsState>(
            listener: (context, state) async {
              if (state.snackText != null) {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(state.snackText)));
              }
            },
            child: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SubscriptionsStatus.LOADING:
                      return LoadingView();
                    case SubscriptionsStatus.OFFERING:
                      return OfferingView(state.offering);
                    case SubscriptionsStatus.ACTIVE:
                      return EntitlementView(state.entitlementInfo);
                    case SubscriptionsStatus.FAILED:
                    default:
                      return ErrorView(
                              () => context.read<SubscriptionsBloc>().reload());
                  }
                })),
      )),
    );
  }
}
