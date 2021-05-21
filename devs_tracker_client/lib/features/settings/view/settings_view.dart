import 'package:devs_tracker_client/features/main/bloc/main_bloc.dart';
import 'package:devs_tracker_client/features/settings/bloc/settings_bloc.dart';
import 'package:devs_tracker_client/features/subscriptions/view/subscriptions_page.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:devs_tracker_client/widgets/main_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  final PurchaseRepository purchaseRepository;

  final int currentBar;
  final MainBloc mainBloc;

  SettingsView(this.purchaseRepository, this.currentBar, this.mainBloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
            if (state.loaded) {
              return LiquidView(
                  child: Column(children: [
                ListTile(
                    title: Text("Subscriptions"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () => Navigator.of(context)
                        .push(SubscriptionsPage.route(purchaseRepository))),
                ListTile(
                    title: Text("Privacy policy"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () =>
                        context.read<SettingsBloc>().openPrivacyPolicy()),
                ListTile(
                    title: Text("Terms & Conditions"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () =>
                        context.read<SettingsBloc>().openTermsAndConditions()),
                ListTile(
                    title: Text("Version"), subtitle: Text(state.data.version))
              ]));
            } else {
              return LoadingView();
            } // Settings
          }),
          bottomNavigationBar: MainBottomNavigationBar(currentBar, mainBloc),
        ));
  }
}
