import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_app.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeveloperEvent {}

class ShowPageEvent extends DeveloperEvent {
  final bool reload;

  ShowPageEvent(this.reload);
}

class DeleteEvent extends DeveloperEvent {}

abstract class DeveloperState {
  TrackedDeveloper trackedDeveloper;

  DeveloperState(this.trackedDeveloper);
}

class LoadingState extends DeveloperState {
  LoadingState(TrackedDeveloper trackedDeveloper) : super(trackedDeveloper);
}

class DeveloperPageState extends DeveloperState {
  final List<DeveloperApp> apps;

  DeveloperPageState(TrackedDeveloper trackedDeveloper, this.apps)
      : super(trackedDeveloper);
}

class DeveloperDeletedState extends DeveloperState {
  DeveloperDeletedState(TrackedDeveloper trackedDeveloper)
      : super(trackedDeveloper);
}

class DeveloperBloc extends Bloc<DeveloperEvent, DeveloperState> {
  final TrackedDeveloper trackedDeveloper;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  List<DeveloperApp> _data;

  DeveloperBloc(
      this.trackedDeveloper, this.purchaseRepository, this.serverRepository)
      : super(LoadingState(trackedDeveloper)) {
    showPage(true);
  }

  @override
  Stream<DeveloperState> mapEventToState(DeveloperEvent event) async* {
    if (event is ShowPageEvent) {
      if (event.reload || _data == null) {
        yield LoadingState(trackedDeveloper);
        await Future.delayed(Duration(seconds: 1));
        _data = List();
      }
      yield DeveloperPageState(trackedDeveloper, _data);
    } else if (event is DeleteEvent) {
      yield LoadingState(trackedDeveloper);
      if (await serverRepository.trackerProvider
          .delete(purchaseRepository.getUserID(), trackedDeveloper.appleId)) {
        print("Developer deleted");
      } else {
        // TODO: handle failed requests, show message etc.// TODO: handle failed requests, show message etc.
      }
      yield DeveloperDeletedState(trackedDeveloper);
    }
  }

  void showPage(reload) {
    add(ShowPageEvent(reload));
  }

  void delete() {
    add(DeleteEvent());
  }
}
