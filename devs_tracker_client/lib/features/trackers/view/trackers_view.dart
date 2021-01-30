import 'package:devs_tracker_client/features/main/bloc/main_bloc.dart';
import 'package:devs_tracker_client/features/search/view/search_page.dart';
import 'package:devs_tracker_client/features/trackers/bloc/trackers_bloc.dart';
import 'package:devs_tracker_client/features/trackers/view/trackers_list.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/error_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:devs_tracker_client/widgets/main_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackersView extends StatelessWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  final int currentBar;
  final MainBloc mainBloc;

  TrackersView(this.dbRepository, this.purchaseRepository,
      this.serverRepository, this.currentBar, this.mainBloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrackersBloc>(
        create: (_) =>
            TrackersBloc(dbRepository, purchaseRepository, serverRepository),
        child:
            BlocBuilder<TrackersBloc, TrackersState>(builder: (context, state) {
          // Settings
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("Trackers"),
              actions: [
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addDeveloper(context))
              ],
            ),
            body: BlocBuilder<TrackersBloc, TrackersState>(
                builder: (context, state) {
              if (state.loaded) {
                if (state.failed) {
                  return ErrorView(() => context.read<TrackersBloc>().reload());
                } else {
                  return TrackersList(state.data);
                }
              } else {
                return LoadingView();
              }
            }),
            bottomNavigationBar: MainBottomNavigationBar(currentBar, mainBloc),
          );
        }));
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
          scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                  "Tracker for \"${searchResult.searchDeveloper.name}\" added!")));
        } else if (searchResult.statusCode == 409) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                  "\"${searchResult.searchDeveloper.name}\" already tracked!")));
        } else {
          print("Home page got unknown statusCode=${searchResult.statusCode}");
        }
        context.read<TrackersBloc>().reload();
      }
    });
  }
}
