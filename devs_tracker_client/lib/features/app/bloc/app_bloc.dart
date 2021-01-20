import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/app_response.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppEvent {}

class ShowPageEvent extends AppEvent {
  final bool reload;

  ShowPageEvent(this.reload);
}

abstract class AppState {
  TrackedDeveloper trackedDeveloper;
  DeveloperApp developerApp;

  AppState(this.trackedDeveloper, this.developerApp);
}

class LoadingState extends AppState {
  LoadingState(TrackedDeveloper trackedDeveloper, DeveloperApp developerApp)
      : super(trackedDeveloper, developerApp);
}

class AppPageState extends AppState {
  final List<String> appCountries;

  AppPageState(TrackedDeveloper trackedDeveloper, DeveloperApp developerApp,
      this.appCountries)
      : super(trackedDeveloper, developerApp);
}

class AppBloc extends Bloc<AppEvent, AppState> {
  final TrackedDeveloper trackedDeveloper;
  final DeveloperApp developerApp;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  List<String> _data;

  AppBloc(this.trackedDeveloper, this.developerApp, this.purchaseRepository,
      this.serverRepository)
      : super(LoadingState(trackedDeveloper, developerApp)) {
    showPage(true);
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ShowPageEvent) {
      if (event.reload || _data == null) {
        yield LoadingState(trackedDeveloper, developerApp);
        AppResponse appResponse = await serverRepository.appProvider
            .get(purchaseRepository.getUserID(), developerApp.appleId);
        _data = appResponse.countries;
      }
      yield AppPageState(trackedDeveloper, developerApp, _data);
    }
  }

  void showPage(reload) {
    add(ShowPageEvent(reload));
  }
}
