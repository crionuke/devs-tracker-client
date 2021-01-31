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
        child: MaterialApp(
          theme: ThemeData(
            cardTheme: CardTheme(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )),
            buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          onGenerateRoute: (_) =>
              LoaderPage.route(
                  dbRepository, purchaseRepository, serverRepository),
        )
    );
  }
}