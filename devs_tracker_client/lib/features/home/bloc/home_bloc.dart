import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}

class ReloadPageEvent extends HomeEvent {}

class HomeState {
  final bool loaded;
  final bool failed;
  final List<DeveloperData> data;

  HomeState.loading()
      : loaded = false,
        failed = false,
        data = null;

  HomeState.loaded(this.data)
      : loaded = true,
        failed = false;

  HomeState.failed()
      : loaded = true,
        failed = true,
        data = null;
}

class DeveloperData {
  final TrackedDeveloper trackedDeveloper;
  final int changes;

  DeveloperData(this.trackedDeveloper, this.changes);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  HomeBloc(this.dbRepository, this.purchaseRepository, this.serverRepository)
      : super(HomeState.loading()) {
    reloadPage();
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is ReloadPageEvent) {
      yield HomeState.loading();
      yield await serverRepository.trackerProvider
          .get(purchaseRepository.getUserID())
          .then((response) {
        print("Trackers loaded, $response");
        List<TrackedDeveloper> developers = response.developers;
        developers.sort((d1, d2) => d2.added.compareTo(d1.added));
        return dbRepository.getAllP().then((map) {
          return HomeState.loaded(developers
              .map((developer) => DeveloperData(developer, 0)).toList());
        }).catchError((error) => HomeState.failed());
      }).catchError((error) {
        print("Error: " + error.toString());
        return HomeState.failed();
      });
    }
  }

  void reloadPage() {
    add(ReloadPageEvent());
  }
}
