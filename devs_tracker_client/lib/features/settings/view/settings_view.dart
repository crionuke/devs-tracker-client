import 'package:devs_tracker_client/features/main/bloc/main_bloc.dart';
import 'package:devs_tracker_client/features/settings/bloc/settings_bloc.dart';
import 'package:devs_tracker_client/widgets/main_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  final int currentBar;
  final MainBloc mainBloc;

  SettingsView(this.currentBar, this.mainBloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(),
        child:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          // Settings
          return Scaffold(
            appBar: AppBar(
              title: Text("Settings"),
            ),
            body: Container(),
            bottomNavigationBar: MainBottomNavigationBar(currentBar, mainBloc),
          );
        }));
  }
}
