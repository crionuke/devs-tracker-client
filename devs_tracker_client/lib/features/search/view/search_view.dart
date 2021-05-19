import 'package:devs_tracker_client/features/search/bloc/search_bloc.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/search_developer.dart';
import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LiquidView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SearchBar<SearchDeveloper>(
          icon: Padding(
              padding: const EdgeInsets.all(10), child: Icon(Icons.search)),
          debounceDuration: Duration(milliseconds: 1000),
          onSearch: context.select((SearchBloc bloc) => bloc.search),
          onError: (error) {
            return ListTile(title: Text("Sorry, something failed, try again"));
          },
          emptyWidget: ListTile(title: Text("No results found")),
          onItemFound: (SearchDeveloper model, int index) {
            return ListTile(
              title: Text(model.name),
              subtitle: Text("id" + model.appleId.toString()),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                context.read<SearchBloc>().select(model);
              },
            );
          }),
    ));
  }
}
