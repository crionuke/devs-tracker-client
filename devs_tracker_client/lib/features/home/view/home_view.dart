import 'package:devs_tracker_client/features/home/view/home_developer_card.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  final List<TrackedDeveloper> developers;

  HomePageView(this.developers);

  @override
  Widget build(BuildContext context) {
    if (developers.isEmpty) {
      return SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(child: Center(child: Text("No trackers")))));
    } else {
      List cards =
          developers.map((developer) => HomeDeveloperCard(developer)).toList();
      return SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: cards)));
    }
  }
}
