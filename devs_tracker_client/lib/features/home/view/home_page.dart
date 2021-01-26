import 'package:devs_tracker_client/features/home/bloc/home_bloc.dart';
import 'package:devs_tracker_client/features/home/view/home_view.dart';
import 'package:devs_tracker_client/features/search/view/search_page.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/error_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static Route route(PurchaseRepository purchaseRepository,
      ServerRepository serverRepository) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            BlocProvider<HomeBloc>(
                create: (_) => HomeBloc(purchaseRepository, serverRepository),
                child: HomePage())
    );
  }

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('Trackers'),
        actions: [
          IconButton(
              icon: Icon(Icons.add), onPressed: () => _addDeveloper(context))
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.loaded) {
            if (state.failed) {
              return ErrorView(() => context.read<HomeBloc>().reloadPage());
            } else {
              return HomePageView(state.data);
            }
          } else {
            return LoadingView();
          }
        },
      ),
    );
  }

  void _addDeveloper(BuildContext context) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    Navigator.of(context)
        .push(SearchPage.route(
        RepositoryProvider.of<PurchaseRepository>(context),
        RepositoryProvider.of<ServerRepository>(context)))
        .then((searchResult) {
      if (searchResult != null) {
        if (searchResult.statusCode == 201) {
          scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(
                  "Tracker for \"${searchResult.searchDeveloper
                      .name}\" added!")));
        } else if (searchResult.statusCode == 409) {
          scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(
                  "\"${searchResult.searchDeveloper
                      .name}\" already tracked!")));
        } else {
          print("Home page got unknown statusCode=${searchResult.statusCode}");
        }
        context.read<HomeBloc>().reloadPage();
      }
    });
  }
}