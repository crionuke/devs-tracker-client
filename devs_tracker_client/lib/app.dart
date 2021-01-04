import 'package:db_repository/db_repository.dart';
import 'package:devs_tracker_client/home/view/home_page.dart';
import 'package:devs_tracker_client/loader/bloc/loader_bloc.dart';
import 'package:devs_tracker_client/loader/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchase_repository/purchase_repository.dart';

class App extends StatelessWidget {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;

  App(this.dbRepository, this.purchaseRepository);

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
        ],
        child: BlocProvider(
          create: (_) => LoaderBloc(dbRepository, purchaseRepository),
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
                    HomePage.route(state), (route) => false);
              }
            },
            child: child);
      },
      onGenerateRoute: (_) => LoaderPage.route(),
    );
  }
}
