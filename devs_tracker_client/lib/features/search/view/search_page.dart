import 'package:devs_tracker_client/features/search/bloc/search_bloc.dart';
import 'package:devs_tracker_client/features/search/view/search_view.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/error_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static Route<SearchResult> route(PurchaseRepository purchaseRepository,
      ServerRepository serverRepository, PushRepository pushRepository) {
    return MaterialPageRoute<SearchResult>(
      builder: (_) => BlocProvider<SearchBloc>(
          create: (_) =>
              SearchBloc(purchaseRepository, serverRepository, pushRepository),
          child: SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) async {
          if (state.finished) {
            Navigator.of(context).pop(state.result);
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state.loading) {
              return LoadingView();
            } else {
              if (state.failed) {
                return ErrorView(() => context.read<SearchBloc>().reload());
              } else {
                return SearchPageView();
              }
            }
          },
        ),
      ),
    );
  }
}
