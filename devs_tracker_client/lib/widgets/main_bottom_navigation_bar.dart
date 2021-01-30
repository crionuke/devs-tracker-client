import 'package:devs_tracker_client/features/main/bloc/main_bloc.dart';
import 'package:flutter/material.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final MainBloc mainBloc;

  MainBottomNavigationBar(this.currentIndex, this.mainBloc);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Trackers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
      currentIndex: currentIndex,
      onTap: (barIndex) => mainBloc.selectBar(barIndex),
    );
  }
}
