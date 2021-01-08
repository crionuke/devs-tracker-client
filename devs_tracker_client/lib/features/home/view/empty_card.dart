import 'package:devs_tracker_client/features/search/view/search_page.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(SearchPage.route(
                  RepositoryProvider.of<ServerRepository>(context)));
            },
            child: Container(
              child: Center(
                child: Icon(Icons.add),
              ),
            )));
  }
}
