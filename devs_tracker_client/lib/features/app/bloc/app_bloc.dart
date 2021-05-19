import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/app_link.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AppEvent {}

class ReloadEvent extends AppEvent {
  ReloadEvent();
}

class AppState {
  final bool loaded;
  final bool failed;
  final bool deleted;
  final TrackedDeveloper trackedDeveloper;
  final DeveloperApp developerApp;
  final List<AppLink> appLinks;

  AppState.loading()
      : loaded = false,
        failed = false,
        deleted = false,
        trackedDeveloper = null,
        developerApp = null,
        appLinks = null;

  AppState.loaded(this.trackedDeveloper, this.developerApp, this.appLinks)
      : loaded = true,
        failed = false,
        deleted = false;

  AppState.failed()
      : loaded = true,
        failed = true,
        deleted = false,
        trackedDeveloper = null,
        developerApp = null,
        appLinks = null;
}

class AppBloc extends Bloc<AppEvent, AppState> {
  final TrackedDeveloper trackedDeveloper;
  final DeveloperApp developerApp;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;
  final PushRepository pushRepository;

  AppBloc(this.trackedDeveloper, this.developerApp, this.purchaseRepository,
      this.serverRepository, this.pushRepository)
      : super(AppState.loading()) {
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => reload());
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ReloadEvent) {
      yield AppState.loading();
      yield await serverRepository.appProvider
          .getLinks(purchaseRepository.getUserID(),
          pushRepository.getDeviceToken(), developerApp.appleId)
          .then((response) {
        print("Links loaded, $response");
        List<AppLink> appLinks = response.links;
        return AppState.loaded(trackedDeveloper, developerApp, appLinks);
      }).catchError((error) {
        print("Error: " + error.toString());
        return AppState.failed();
      });
    }
  }

  void reload() {
    add(ReloadEvent());
  }

  void openApp(String url) {
    print("Open url, $url");
    launch(url);
  }
}
