import 'package:devs_tracker_client/features/app/view/app_page.dart';
import 'package:devs_tracker_client/features/developer/bloc/developer_bloc.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DeveloperView extends StatelessWidget {
  final List<DeveloperApp> apps;

  DeveloperView(this.apps);

  @override
  Widget build(BuildContext context) {
    if (apps.isEmpty) {
      return NoAppsView();
    } else {
      final Locale locale = Localizations.localeOf(context);
      final DateFormat format = DateFormat.yMMMMd(locale.toString());
      return AppsList(apps, format);
    }
  }
}

class NoAppsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LiquidView(
        child:
            Center(child: Text("Developer has no apps or it in processing")));
  }
}

class AppsList extends StatelessWidget {
  final List<DeveloperApp> apps;
  final DateFormat format;

  AppsList(this.apps, this.format);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          DeveloperApp app = apps[index];
          return ListTile(
              title: Text(app.title),
              subtitle: Text("Release date: " +
                  format.format(app.releaseDate.toLocal()).toString()),
              leading: Text((index + 1).toString()),
              trailing: Icon(Icons.navigate_next),
              onTap: () => _showApp(context, app));
        });
  }

  void _showApp(BuildContext context, DeveloperApp app) {
    Navigator.of(context).push(AppPage.route(
        context.read<DeveloperBloc>().trackedDeveloper,
        app,
        RepositoryProvider.of<PurchaseRepository>(context),
        RepositoryProvider.of<ServerRepository>(context),
        RepositoryProvider.of<PushRepository>(context)));
  }
}
