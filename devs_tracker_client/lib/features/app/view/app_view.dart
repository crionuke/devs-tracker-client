import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:flutter/material.dart';

class AppView extends StatelessWidget {
  final DeveloperApp developerApp;
  final List<String> countries;

  AppView(this.developerApp, this.countries);

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) {
      return NoCountriesView();
    } else {
      return CountriesList(countries);
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
  final List<String> countries;

  CountriesList(this.countries);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(countries[index]),
                    leading: Text((index + 1).toString()),
                    trailing: Icon(Icons.navigate_next),
                  );
                })));
  }
}
