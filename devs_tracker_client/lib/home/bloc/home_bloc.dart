import 'package:db_repository/db_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchase_repository/purchase_repository.dart';

abstract class HomeEvent {}

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DbRepository dbRepository;
  final PurchaseRepository purchaseRepository;

  HomeBloc(this.dbRepository, this.purchaseRepository)
      : super(HomeInitialState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield HomeInitialState();
  }
}
