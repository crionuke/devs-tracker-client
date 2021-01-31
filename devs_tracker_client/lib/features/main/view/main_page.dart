import 'package:devs_tracker_client/features/main/bloc/main_bloc.dart';
import 'package:devs_tracker_client/features/settings/view/settings_view.dart';
import 'package:devs_tracker_client/features/trackers/view/trackers_view.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  static Route route(
      DbRepository dbRepository,
      PurchaseRepository purchaseRepository,
      ServerRepository serverRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider<MainBloc>(
            create: (_) => MainBloc(),
            child:
                MainPage(dbRepository, purchaseRepository, serverRepository)));
  }

  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  MainPage(this.dbRepository, this.purchaseRepository, this.serverRepository);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      return IndexedStack(
        index: state.currentBar,
        children: [
          TrackersView(dbRepository, purchaseRepository, serverRepository,
              state.currentBar, context.select((MainBloc bloc) => bloc)),
          SettingsView(purchaseRepository, state.currentBar,
              context.select((MainBloc bloc) => bloc))
        ],
      );
    });
  }
}
