import 'package:devs_tracker_client/features/loader/bloc/loader_bloc.dart';
import 'package:devs_tracker_client/features/main/view/main_page.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoaderPage extends StatelessWidget {
  static Route route(
      DbRepository dbRepository,
      PurchaseRepository purchaseRepository,
      ServerRepository serverRepository,
      PushRepository pushRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider<LoaderBloc>(
            create: (_) => LoaderBloc(dbRepository, purchaseRepository,
                serverRepository, pushRepository),
            child: LoaderPage(dbRepository, purchaseRepository,
                serverRepository, pushRepository)));
  }

  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;
  final PushRepository pushRepository;

  LoaderPage(this.dbRepository, this.purchaseRepository, this.serverRepository,
      this.pushRepository);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderBloc, LoaderState>(
        listener: (context, state) async {
      if (state is Loaded) {
        Navigator.of(context).pushAndRemoveUntil(
            MainPage.route(dbRepository, purchaseRepository, serverRepository,
                pushRepository),
            (route) => false);
      }
    }, child: BlocBuilder<LoaderBloc, LoaderState>(builder: (context, state) {
      return Scaffold(body: LoadingView());
    }));
  }
}
