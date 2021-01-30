import 'package:devs_tracker_client/features/developer/view/developer_page.dart';
import 'package:devs_tracker_client/features/trackers/bloc/trackers_bloc.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackerCard extends StatelessWidget {
  final DeveloperData developerData;

  TrackerCard(this.developerData);

  @override
  Widget build(BuildContext context) {
    if (developerData.changes > 0) {
      return Stack(children: [
        DeveloperCard(developerData),
        NewAppsBar(developerData)
      ]);
    } else {
      return Stack(children: [
        DeveloperCard(developerData),
      ]);
    }
  }
}

class DeveloperCard extends StatelessWidget {

  final DeveloperData developerData;

  DeveloperCard(this.developerData);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () => _showDeveloper(context),
          child: Container(
              child: Center(
                child: Text(
                  "${developerData.trackedDeveloper.name}\n"
                      "(id${developerData.trackedDeveloper.appleId})",
                  textAlign: TextAlign.center,
                ),
              )),
        ));
  }

  void _showDeveloper(BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Navigator.of(context)
        .push(DeveloperPage.route(developerData.trackedDeveloper,
        RepositoryProvider.of<PurchaseRepository>(context),
        RepositoryProvider.of<ServerRepository>(context)))
        .then((deleted) {
      if (deleted != null && deleted) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(
                "Tracker for "
                    "\"${developerData.trackedDeveloper.name}\" deleted!")));
      }
      context.read<TrackersBloc>().reload();
    });
  }
}

class NewAppsBar extends StatelessWidget {

  final DeveloperData developerData;

  NewAppsBar(this.developerData);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12
          ),
          margin: EdgeInsets.all(10),
          child: Center(child: Text(developerData.changes.toString())),
        ));
  }
}