import 'package:devs_tracker_client/features/main/bloc/main_bloc.dart';
import 'package:devs_tracker_client/features/settings/view/settings_view.dart';
import 'package:devs_tracker_client/features/trackers/view/trackers_view.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/error_view.dart';
import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  static Route route(
      DbRepository dbRepository,
      PurchaseRepository purchaseRepository,
      ServerRepository serverRepository,
      PushRepository pushRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider<MainBloc>(
            create: (_) =>
                MainBloc(purchaseRepository, serverRepository, pushRepository),
            child: MainPage(dbRepository, purchaseRepository, serverRepository,
                pushRepository)));
  }

  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;
  final PushRepository pushRepository;

  MainPage(this.dbRepository, this.purchaseRepository, this.serverRepository,
      this.pushRepository);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      if (state.loaded) {
        if (state.failed) {
          return Scaffold(
              body: ErrorView(() => context.read<MainBloc>().reload()));
        } else {
          return IndexedStack(
            index: state.currentBar,
            children: [
              TrackersView(
                  dbRepository,
                  purchaseRepository,
                  serverRepository,
                  pushRepository,
                  state.currentBar,
                  context.select((MainBloc bloc) => bloc)),
              SettingsView(purchaseRepository, state.currentBar,
                  context.select((MainBloc bloc) => bloc))
            ],
          );
        }
      } else {
        return Scaffold(body: LiquidView(child: LoadingView()));
      }
    });
  }
}
