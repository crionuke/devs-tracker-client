import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TrackersEvent {}

class ReloadEvent extends TrackersEvent {}

class TrackersState {
  final bool loaded;
  final bool failed;
  final List<DeveloperData> data;

  TrackersState.loading()
      : loaded = false,
        failed = false,
        data = null;

  TrackersState.loaded(this.data)
      : loaded = true,
        failed = false;

  TrackersState.failed()
      : loaded = true,
        failed = true,
        data = null;
}

class DeveloperData {
  final TrackedDeveloper trackedDeveloper;
  final int changes;

  DeveloperData(this.trackedDeveloper, this.changes);
}

class TrackersBloc extends Bloc<TrackersEvent, TrackersState> {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  TrackersBloc(this.dbRepository, this.purchaseRepository,
      this.serverRepository)
      : super(TrackersState.loading()) {
    reload();
  }

  @override
  Stream<TrackersState> mapEventToState(TrackersEvent event) async* {
    if (event is ReloadEvent) {
      yield TrackersState.loading();
      yield await serverRepository.trackerProvider
          .get(purchaseRepository.getUserID())
          .then((response) {
        print("Trackers loaded, $response");
        List<TrackedDeveloper> developers = response.developers;
        developers.sort((d1, d2) => d2.added.compareTo(d1.added));
        return dbRepository.getAllP().then((map) {
          return TrackersState.loaded(developers
              .map((developer) => DeveloperData(developer, developer.count))
              .toList());
        }).catchError((error) => TrackersState.failed());
      }).catchError((error) {
        print("Error: " + error.toString());
        return TrackersState.failed();
      });
    }
  }

  void reload() {
    add(ReloadEvent());
  }
}
