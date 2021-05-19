import 'package:devs_tracker_client/features/subscriptions/bloc/offerings_bloc.dart';
import 'package:devs_tracker_client/features/subscriptions/bloc/subscriptions_bloc.dart';
import 'package:devs_tracker_client/features/subscriptions/view/package_view.dart';
import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class OfferingView extends StatelessWidget {
  final Offering offering;

  OfferingView(this.offering);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfferingBloc>(
        create: (_) => OfferingBloc(offering.annual),
        child:
            BlocBuilder<OfferingBloc, OfferingState>(builder: (context, state) {
          return LiquidView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    PackageView(
                      package: offering.monthly,
                      onTap: () => context
                          .read<OfferingBloc>()
                          .selectPackage(offering.monthly),
                      selected: state.package.identifier ==
                          offering.monthly.identifier,
                    ),
                    PackageView(
                      package: offering.annual,
                      description: offering.annual.product.description,
                      onTap: () => context
                          .read<OfferingBloc>()
                          .selectPackage(offering.annual),
                      selected: state.package.identifier ==
                          offering.annual.identifier,
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FlatButton(
                        onPressed: () {
                          context
                              .read<SubscriptionsBloc>()
                              .purchase(state.package);
                        },
                        child: Text("Continue")))
              ]));
        }));
  }
}
