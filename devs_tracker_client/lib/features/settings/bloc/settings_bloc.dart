import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SettingsEvent {}

class SettingsState {}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {}
}
