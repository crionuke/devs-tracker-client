import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MainEvent {}

class ReloadEvent extends MainEvent {}

class BarSelected extends MainEvent {
  final int barIndex;

  BarSelected(this.barIndex);
}

class MainState {
  final bool loaded;
  final bool failed;
  final int currentBar;

  MainState.loading()
      : loaded = false,
        failed = false,
        currentBar = null;

  MainState.loaded(this.currentBar)
      : loaded = true,
        failed = false;

  MainState.failed()
      : loaded = true,
        failed = true,
        currentBar = null;
}

class MainBloc extends Bloc<MainEvent, MainState> {
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;
  final PushRepository pushRepository;

  MainBloc(this.purchaseRepository, this.serverRepository, this.pushRepository)
      : super(MainState.loading()) {
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => reload());
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is ReloadEvent) {
      yield MainState.loading();
      // Sign-in
      yield await serverRepository.userProvider
          .signIn(
              purchaseRepository.getUserID(), pushRepository.getDeviceToken())
          .then((_) {
        return MainState.loaded(0);
      }).catchError((error) {
        print("Error: " + error.toString());
        return MainState.failed();
      });
//      // Restore first
//      yield await purchaseRepository.restore().then((purchaserInfo) async {
//        print("Restore finished, $purchaserInfo");
//        // Sign-in
//        return await serverRepository.userProvider
//            .signIn(
//                purchaseRepository.getUserID(), pushRepository.getDeviceToken())
//            .then((_) {
//          return MainState.loaded(0);
//        }).catchError((error) {
//          print("Error: " + error.toString());
//          return MainState.failed();
//        });
//      }).catchError((error) {
//        print("Error: " + error.toString());
//        return MainState.failed();
//      });
    } else if (event is BarSelected) {
      yield MainState.loaded(event.barIndex);
    }
  }

  void selectBar(int barIndex) {
    add(BarSelected(barIndex));
  }

  void reload() async {
    add(ReloadEvent());
  }
}
