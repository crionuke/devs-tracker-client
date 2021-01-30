import 'package:devs_tracker_client/features/main/bloc/main_bloc.dart';
import 'package:devs_tracker_client/features/settings/bloc/settings_bloc.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
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
        child: Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state.loaded) {
                  return Column(
                      children: [
                        ListTile(title: Text(state.data.version))
                      ]);
                } else {
                  return LoadingView();
                }
                // Settings
              }),
          bottomNavigationBar: MainBottomNavigationBar(currentBar, mainBloc),
        )
    );
  }
}
