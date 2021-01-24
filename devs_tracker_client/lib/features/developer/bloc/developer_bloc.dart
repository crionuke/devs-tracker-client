import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeveloperEvent {}

class ReloadPageEvent extends DeveloperEvent {}

class DeleteAppEvent extends DeveloperEvent {}

class DeveloperState {
  final bool loaded;
  final bool failed;
  final bool deleted;
  final List<DeveloperApp> data;

  DeveloperState.loading()
      : loaded = false,
        failed = false,
        deleted = false,
        data = null;

  DeveloperState.loaded(this.data)
      : loaded = true,
        failed = false,
        deleted = false;

  DeveloperState.deleted()
      : loaded = false,
        failed = false,
        deleted = true,
        data = null;

  DeveloperState.failed()
      : loaded = true,
        failed = true,
        deleted = false,
        data = null;
}

class DeveloperBloc extends Bloc<DeveloperEvent, DeveloperState> {
  final TrackedDeveloper trackedDeveloper;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  DeveloperBloc(
      this.trackedDeveloper, this.purchaseRepository, this.serverRepository)
      : super(DeveloperState.loading()) {
    reloadPage();
  }

  @override
  Stream<DeveloperState> mapEventToState(DeveloperEvent event) async* {
    if (event is ReloadPageEvent) {
      yield DeveloperState.loading();
      yield await serverRepository.developerProvider
          .getApps(purchaseRepository.getUserID(), trackedDeveloper.appleId)
          .then((response) {
        List<DeveloperApp> data = response.apps;
        data.sort((d1, d2) => d2.releaseDate.compareTo(d1.releaseDate));
        return DeveloperState.loaded(data);
      }).catchError((error) {
        print("Error: " + error.toString());
        return DeveloperState.failed();
      });
    } else if (event is DeleteAppEvent) {
      yield DeveloperState.loading();
      yield await serverRepository.trackerProvider
          .delete(purchaseRepository.getUserID(), trackedDeveloper.appleId)
          .then((_) => DeveloperState.deleted())
          .catchError((error) {
        print("Error: " + error.toString());
        return DeveloperState.failed();
      });
    }
  }

  void reloadPage() {
    add(ReloadPageEvent());
  }

  void delete() {
    add(DeleteAppEvent());
  }
}
