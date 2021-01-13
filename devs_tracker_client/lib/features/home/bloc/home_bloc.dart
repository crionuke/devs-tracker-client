import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_response.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}

class ShowPageEvent extends HomeEvent {
  final bool reload;

  ShowPageEvent(this.reload);
}

class AddDeveloperEvent extends HomeEvent {}

class ShowDeveloperEvent extends HomeEvent {
  final TrackedDeveloper developer;

  ShowDeveloperEvent(this.developer);
}

abstract class HomeState {}

class HomeLoadingState extends HomeState {}

class HomePageState extends HomeState {
  final List<TrackedDeveloper> developers;

  HomePageState(this.developers);
}

class AddDeveloperState extends HomeState {}

class ShowDeveloperState extends HomeState {
  final TrackedDeveloper developer;

  ShowDeveloperState(this.developer);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  List<TrackedDeveloper> _data;

  HomeBloc(this.purchaseRepository, this.serverRepository)
      : super(HomeLoadingState()) {
    showPage(true);
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is ShowPageEvent) {
      if (event.reload || _data == null) {
        yield HomeLoadingState();
        TrackedResponse trackedResponse = await serverRepository.trackerProvider
            .get(purchaseRepository.getUserID());
        print("Trackers loaded, $trackedResponse");
        _data = trackedResponse.developers;
        _data.sort((d1, d2) => d1.added.compareTo(d2.added));
      }
      yield HomePageState(_data);
    } else if (event is AddDeveloperEvent) {
      yield AddDeveloperState();
    } else if (event is ShowDeveloperEvent) {
      yield ShowDeveloperState(event.developer);
    }
  }


  void showPage(reload) {
    add(ShowPageEvent(reload));
  }

  void addDeveloper() {
    add(AddDeveloperEvent());
  }

  void showDeveloper(TrackedDeveloper developer) {
    add(ShowDeveloperEvent(developer));
  }
}
