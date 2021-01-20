import 'package:devs_tracker_client/features/app/bloc/app_bloc.dart';
import 'package:devs_tracker_client/features/app/view/app_view.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppPage extends StatelessWidget {
  static Route route(
      TrackedDeveloper trackedDeveloper,
      DeveloperApp developerApp,
      PurchaseRepository purchaseRepository,
      ServerRepository serverRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider<AppBloc>(
            create: (_) => AppBloc(trackedDeveloper, developerApp,
                purchaseRepository, serverRepository),
            child: AppPage()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
        listener: (context, state) async {
          //
        },
        child: Scaffold(
          appBar: AppBar(
            title:
                Text(context.select((AppBloc bloc) => bloc.developerApp.title)),
          ),
          body: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state is AppPageState) {
                return AppView(state.developerApp, state.appCountries);
              } else {
                return LoadingView();
              }
            },
          ),
        ));
  }
}
