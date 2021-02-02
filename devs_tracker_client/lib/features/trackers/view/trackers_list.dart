import 'package:devs_tracker_client/features/trackers/bloc/trackers_bloc.dart';
import 'package:devs_tracker_client/features/trackers/view/tracker_card.dart';
import 'package:flutter/material.dart';

class TrackersList extends StatelessWidget {
  final List<DeveloperData> developers;

  TrackersList(this.developers);

  @override
  Widget build(BuildContext context) {
    if (developers.isEmpty) {
      return Container(child: Center(child: Text("No trackers")));
    } else {
      List cards =
          developers.map((developer) => TrackerCard(developer)).toList();
      return GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
          children: cards);
    }
  }
}
