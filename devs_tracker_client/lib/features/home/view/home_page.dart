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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    Navigator.of(context)
        .push(SearchPage.route(
        RepositoryProvider.of<PurchaseRepository>(context),
        RepositoryProvider.of<ServerRepository>(context)))
        .then((affected) {
      if (affected != null && affected) {
        context.read<HomeBloc>().reloadPage();
      }
    });
  }
}