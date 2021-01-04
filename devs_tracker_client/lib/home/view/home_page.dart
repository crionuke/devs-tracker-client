import 'package:devs_tracker_client/home/bloc/home_bloc.dart';
import 'package:devs_tracker_client/loader/bloc/loader_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static Route route(RepositoriesLoaded repositoriesLoaded) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(repositoriesLoaded.dbRepository,
              repositoriesLoaded.purchaseRepository),
          child: HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DEVS TRACKER')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
