import 'package:devs_tracker_client/features/home/bloc/home_bloc.dart';
import 'package:devs_tracker_client/features/home/view/empty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(),
          child: HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracker')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    EmptyCard(),
                  ],)),
          );
        },
      ),
    );
  }
}


