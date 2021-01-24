import 'package:devs_tracker_client/repositories/server_repository/providers/model/app_link.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:flutter/material.dart';

class AppView extends StatelessWidget {
  final DeveloperApp developerApp;
  final List<AppLink> links;

  AppView(this.developerApp, this.links);

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) {
      return NoCountriesView();
    } else {
      return CountriesList(links);
    }
  }
}

class NoCountriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(child: Center(child: Text("No links")))));
  }
}

class CountriesList extends StatelessWidget {
  final List<AppLink> links;

  CountriesList(this.links);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
                itemCount: links.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${links[index].title}"),
//                    leading: Text((index + 1).toString()),
                    leading: Text("[${links[index].country}]"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                    },
                  );
                })));
  }
}
