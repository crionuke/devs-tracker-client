import 'package:devs_tracker_client/features/developer/view/developer_page.dart';
import 'package:devs_tracker_client/features/home/bloc/home_bloc.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDeveloperCard extends StatelessWidget {
  final TrackedDeveloper trackedDeveloper;

  HomeDeveloperCard(this.trackedDeveloper);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () => _showDeveloper(context),
      child: Container(
          child: Stack(
        children: [
          Center(
            child: Text(
              "${trackedDeveloper.name}\n(id${trackedDeveloper.appleId})",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    ));
  }

  void _showDeveloper(BuildContext context) {
    Navigator.of(context)
        .push(DeveloperPage.route(trackedDeveloper,
        RepositoryProvider.of<PurchaseRepository>(context),
        RepositoryProvider.of<ServerRepository>(context)))
        .then((affected) {
      if (affected != null && affected) {
        context.read<HomeBloc>().reloadPage();
      }
    });
  }
}
