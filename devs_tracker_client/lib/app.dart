import 'package:devs_tracker_client/features/home/view/home_page.dart';
import 'package:devs_tracker_client/features/loader/bloc/loader_bloc.dart';
import 'package:devs_tracker_client/features/loader/view/loader_page.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final DbRepository dbRepository;
  final ServerRepository serverRepository;
  final PurchaseRepository purchaseRepository;

  App(this.dbRepository, this.purchaseRepository, this.serverRepository);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DbRepository>(
            create: (context) => dbRepository,
          ),
          RepositoryProvider<PurchaseRepository>(
            create: (context) => purchaseRepository,
          ),
          RepositoryProvider<ServerRepository>(
            create: (context) => serverRepository,
          ),
        ],
        child: BlocProvider(
          create: (_) =>
              LoaderBloc(dbRepository, purchaseRepository, serverRepository),
          child: AppView(),
        ));
  }
}

class AppView extends StatefulWidget {
  @override
  State createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<LoaderBloc, LoaderState>(
            listener: (context, state) {
              if (state is RepositoriesLoaded) {
                _navigator.pushAndRemoveUntil(
                    HomePage.route(
                        RepositoryProvider.of<PurchaseRepository>(context),
                        RepositoryProvider.of<ServerRepository>(context)), (
                    route) => false);
              }
            },
            child: child);
      },
      onGenerateRoute: (_) => LoaderPage.route(),
    );
  }
}
