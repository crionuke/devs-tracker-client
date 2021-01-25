import 'package:devs_tracker_client/features/developer/bloc/developer_bloc.dart';
import 'package:devs_tracker_client/features/developer/view/developer_view.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/error_view.dart';
import 'package:devs_tracker_client/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeveloperPage extends StatelessWidget {
  static Route route(TrackedDeveloper trackedDeveloper,
      PurchaseRepository purchaseRepository,
      ServerRepository serverRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider<DeveloperBloc>(
            create: (_) => DeveloperBloc(
                trackedDeveloper, purchaseRepository, serverRepository),
            child: DeveloperPage()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeveloperBloc, DeveloperState>(
        listener: (context, state) async {
          if (state.deleted) {
            Navigator.of(context).pop(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context
                .select((DeveloperBloc bloc) => bloc.trackedDeveloper.name)),
            actions: [
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    context.read<DeveloperBloc>().delete();
                  })
            ],
          ),
          body: BlocBuilder<DeveloperBloc, DeveloperState>(
            builder: (context, state) {
              if (state.loaded) {
                if (state.failed) {
                  return ErrorView(() =>
                      context.read<DeveloperBloc>().reloadPage());
                } else {
                  return DeveloperView(state.data);
                }
              } else {
                return LoadingView();
              }
            },
          ),
        ));
  }
}
