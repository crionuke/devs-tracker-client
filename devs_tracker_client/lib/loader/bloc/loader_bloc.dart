import 'dart:async';

import 'package:db_repository/db_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchase_repository/purchase_repository.dart';

abstract class LoaderEvent {}

class DbRepositoryLoaded extends LoaderEvent {}

class PurchaseRepositoryLoaded extends LoaderEvent {}

abstract class LoaderState {}

class RepositoriesLoading extends LoaderState {}

class RepositoriesLoaded extends LoaderState {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;

  RepositoriesLoaded(this.dbRepository, this.purchaseRepository);
}

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;

  StreamSubscription<DbRepositoryStatus> _dbRepositoryStatusSubscription;
  StreamSubscription<PurchaseRepositoryStatus>
      _purchaseRepositoryStatusSubscription;

  bool _dbRepositoryLoaded;
  bool _purchaseRepositoryLoaded;

  LoaderBloc(this.dbRepository, this.purchaseRepository)
      : super(RepositoriesLoading()) {
    _dbRepositoryLoaded = false;
    _purchaseRepositoryLoaded = false;
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
  }

  @override
  Stream<LoaderState> mapEventToState(LoaderEvent event) async* {
    if (event is DbRepositoryLoaded) {
      _dbRepositoryLoaded = true;
    } else if (event is PurchaseRepositoryLoaded) {
      _purchaseRepositoryLoaded = true;
    }
    if (_dbRepositoryLoaded && _purchaseRepositoryLoaded) {
      print("All repositories loaded");
      yield RepositoriesLoaded(dbRepository, purchaseRepository);
    }
  }

  @override
  Future<Function> close() {
    _dbRepositoryStatusSubscription.cancel();
    _purchaseRepositoryStatusSubscription.cancel();
    return super.close();
  }
}
