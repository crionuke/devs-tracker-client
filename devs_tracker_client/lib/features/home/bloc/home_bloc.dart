import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitialState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield HomeInitialState();
  }
}
