import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}

class ReloadPageEvent extends HomeEvent {}

class HomeState {
  final bool loaded;
  final bool failed;
  final List<TrackedDeveloper> data;

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

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  HomeBloc(this.purchaseRepository, this.serverRepository)
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
        List<TrackedDeveloper> data = response.developers;
        data.sort((d1, d2) => d2.added.compareTo(d1.added));
        return HomeState.loaded(data);
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
