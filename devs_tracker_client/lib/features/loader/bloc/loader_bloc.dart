import 'dart:async';

import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoaderEvent {}

class DbRepositoryLoaded extends LoaderEvent {}

class PurchaseRepositoryLoaded extends LoaderEvent {}

class ServerRepositoryLoaded extends LoaderEvent {}

class PushRepositoryLoaded extends LoaderEvent {}

abstract class LoaderState {}

class Loading extends LoaderState {}

class Loaded extends LoaderState {}

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;
  final PushRepository pushRepository;

  StreamSubscription<DbRepositoryStatus> _dbRepositoryStatusSubscription;
  StreamSubscription<PurchaseRepositoryStatus>
      _purchaseRepositoryStatusSubscription;
  StreamSubscription<ServerRepositoryStatus>
      _serverRepositoryStatusSubscription;
  StreamSubscription<PushRepositoryStatus> _pushRepositoryStatusSubscription;

  bool _dbRepositoryLoaded;
  bool _purchaseRepositoryLoaded;
  bool _serverRepositoryLoaded;
  bool _pushRepositoryLoaded;

  LoaderBloc(this.dbRepository, this.purchaseRepository, this.serverRepository,
      this.pushRepository)
      : super(Loading()) {
    _dbRepositoryLoaded = false;
    _purchaseRepositoryLoaded = false;
    _serverRepositoryLoaded = false;
    _pushRepositoryLoaded = false;
    _dbRepositoryStatusSubscription = dbRepository.status.listen((status) {
      if (status == DbRepositoryStatus.loaded) {
        print("DbRepository loaded");
        add(DbRepositoryLoaded());
      }
    });
    _purchaseRepositoryStatusSubscription =
        purchaseRepository.status.listen((status) {
      if (status == PurchaseRepositoryStatus.loaded) {
        print("PurchaseRepository loaded");
        add(PurchaseRepositoryLoaded());
      }
    });
    _serverRepositoryStatusSubscription =
        serverRepository.status.listen((status) {
      if (status == ServerRepositoryStatus.loaded) {
        print("ServerRepository loaded");
        add(ServerRepositoryLoaded());
      }
    });
    _pushRepositoryStatusSubscription = pushRepository.status.listen((status) {
      if (status == PushRepositoryStatus.loaded) {
        print("PushRepository loaded");
        add(PushRepositoryLoaded());
      }
    });
  }

  @override
  Stream<LoaderState> mapEventToState(LoaderEvent event) async* {
    if (event is DbRepositoryLoaded) {
      _dbRepositoryLoaded = true;
    } else if (event is PurchaseRepositoryLoaded) {
      _purchaseRepositoryLoaded = true;
    } else if (event is ServerRepositoryLoaded) {
      _serverRepositoryLoaded = true;
    } else if (event is PushRepositoryLoaded) {
      _pushRepositoryLoaded = true;
    }
    if (_dbRepositoryLoaded &&
        _purchaseRepositoryLoaded &&
        _serverRepositoryLoaded && _pushRepositoryLoaded) {
      print("All repositories loaded");
      yield Loaded();
    }
  }

  @override
  Future<void> close() {
    _dbRepositoryStatusSubscription.cancel();
    _purchaseRepositoryStatusSubscription.cancel();
    _serverRepositoryStatusSubscription.cancel();
    _pushRepositoryStatusSubscription.cancel();
    return super.close();
  }
}
