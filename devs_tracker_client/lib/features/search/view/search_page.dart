import 'package:devs_tracker_client/features/search/bloc/search_bloc.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/search_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitialState) {
            return SearchInitialView();
          } else if (state is SearchLoadingState) {
            return SearchLoadingView();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class SearchInitialView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SearchBar<SearchDeveloper>(
            icon: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.search)),
            debounceDuration: Duration(milliseconds: 1000),
            onSearch: context.select((SearchBloc bloc) => bloc.search),
            onItemFound: (SearchDeveloper model, int index) {
              return ListTile(
                title: Text(model.name),
                subtitle: Text("id" + model.appleId.toString()),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  context.read<SearchBloc>().select(model.appleId);
                },
              );
            }),
      ),
    );
  }
}

class SearchLoadingView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
