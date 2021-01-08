import 'package:devs_tracker_client/features/search/bloc/search_bloc.dart';
import 'package:devs_tracker_client/repositories/server_repository/developers_provider/model/developer_model.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static Route route(ServerRepository serverRepository) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(serverRepository), child: SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBar<DeveloperModel>(
                  icon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(Icons.search)),
                  debounceDuration: Duration(milliseconds: 1000),
                  onSearch: context.select((SearchBloc bloc) => bloc.search),
                  onItemFound: (DeveloperModel model, int index) {
                    return ListTile(
                      title: Text(model.name),
                      subtitle: Text("id" + model.id.toString()),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
