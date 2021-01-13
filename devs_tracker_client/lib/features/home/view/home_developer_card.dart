import 'package:devs_tracker_client/features/home/bloc/home_bloc.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDeveloperCard extends StatelessWidget {
  final TrackedDeveloper trackedDeveloper;

  HomeDeveloperCard(this.trackedDeveloper);

  @override
  Widget build(BuildContext context) {
    final String title =
        "${trackedDeveloper.name}\n${trackedDeveloper.appleId}";
    return Card(
        child: InkWell(
            onTap: () {
              context.read<HomeBloc>().showDeveloper(trackedDeveloper);
            },
            child: Container(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            )));
  }
}
