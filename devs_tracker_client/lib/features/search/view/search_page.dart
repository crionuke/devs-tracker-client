import 'package:devs_tracker_client/features/search/bloc/search_bloc.dart';
import 'package:devs_tracker_client/features/search/view/search_view.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static Route route(PurchaseRepository puchaseRepository,
      ServerRepository serverRepository) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(puchaseRepository, serverRepository),
          child: SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
        listener: (context, state) async {
          if (state is SearchFinishedState) {
            Navigator.of(context).pop(true);
          }
        }, child: Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchPageState) {
            return SearchPageView();
          } else {
            return LoadingView();
          }
        },
      ),
    ));
  }
}

