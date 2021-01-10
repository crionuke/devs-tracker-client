import 'dart:async';

import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoaderEvent {}

class DbRepositoryLoaded extends LoaderEvent {}

class PurchaseRepositoryLoaded extends LoaderEvent {}

class ServerRepositoryLoaded extends LoaderEvent {}

abstract class LoaderState {}

class RepositoriesLoading extends LoaderState {}

class RepositoriesLoaded extends LoaderState {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  RepositoriesLoaded(this.dbRepository, this.purchaseRepository,
      this.serverRepository);
}

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  StreamSubscription<DbRepositoryStatus> _dbRepositoryStatusSubscription;
  StreamSubscription<PurchaseRepositoryStatus>
      _purchaseRepositoryStatusSubscription;
  StreamSubscription<
      ServerRepositoryStatus> _serverRepositoryStatusSubscription;

  bool _dbRepositoryLoaded;
  bool _purchaseRepositoryLoaded;
  bool _serverRepositoryLoaded;

  LoaderBloc(this.dbRepository, this.purchaseRepository, this.serverRepository)
      : super(RepositoriesLoading()) {
    _dbRepositoryLoaded = false;
    _purchaseRepositoryLoaded = false;
    _serverRepositoryLoaded = false;
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
  }

  @override
  Stream<LoaderState> mapEventToState(LoaderEvent event) async* {
    if (event is DbRepositoryLoaded) {
      _dbRepositoryLoaded = true;
    } else if (event is PurchaseRepositoryLoaded) {
      _purchaseRepositoryLoaded = true;
    } else if (event is ServerRepositoryLoaded) {
      _serverRepositoryLoaded = true;
    }
    if (_dbRepositoryLoaded && _purchaseRepositoryLoaded &&
        _serverRepositoryLoaded) {
      print("All repositories loaded");
      yield RepositoriesLoaded(
          dbRepository, purchaseRepository, serverRepository);
    }
  }

  @override
  Future<Function> close() {
    _dbRepositoryStatusSubscription.cancel();
    _purchaseRepositoryStatusSubscription.cancel();
    _serverRepositoryStatusSubscription.cancel();
    return super.close();
  }
}