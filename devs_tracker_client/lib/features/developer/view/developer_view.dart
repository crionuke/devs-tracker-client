import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:flutter/material.dart';

class DeveloperPageView extends StatelessWidget {
  final List<DeveloperApp> app;

  DeveloperPageView(this.app);

  @override
  Widget build(BuildContext context) {
    if (app.isEmpty) {
      return SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(child: Center(child: Text("No apps")))));
    } else {
      return SafeArea(
          child:
              Padding(padding: const EdgeInsets.all(20), child: Container()));
    }
  }
}
