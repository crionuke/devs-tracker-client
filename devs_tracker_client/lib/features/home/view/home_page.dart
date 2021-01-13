import 'package:devs_tracker_client/features/developer/view/developer_page.dart';
import 'package:devs_tracker_client/features/home/bloc/home_bloc.dart';
import 'package:devs_tracker_client/features/home/view/home_view.dart';
import 'package:devs_tracker_client/features/search/view/search_page.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(listener: (context, state) async {
      if (state is AddDeveloperState) {
        Route route = SearchPage.route(
            RepositoryProvider.of<PurchaseRepository>(context),
            RepositoryProvider.of<ServerRepository>(context));
        await Navigator.of(context)
            .push(route)
            .then((affected) {
          if (affected != null && affected) {
            context.read<HomeBloc>().showPage(true);
          } else {
            context.read<HomeBloc>().showPage(false);
          }
        });
      } else if (state is ShowDeveloperState) {
        Route route = DeveloperPage.route(state.developer,
            RepositoryProvider.of<PurchaseRepository>(context),
            RepositoryProvider.of<ServerRepository>(context));
        await Navigator.of(context)
            .push(route)
            .then((affected) {
          if (affected != null && affected) {
            context.read<HomeBloc>().showPage(true);
          } else {
            context.read<HomeBloc>().showPage(false);
          }
        });
      }
    }, child: Scaffold(
      appBar: AppBar(title: const Text('Trackers'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () {
            context.read<HomeBloc>().addDeveloper();
          })
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomePageState) {
            HomePageState homePageState = state;
            return HomePageView(homePageState.developers);
          } else {
            return LoadingView();
          }
        },
      ),
    ));
  }
}