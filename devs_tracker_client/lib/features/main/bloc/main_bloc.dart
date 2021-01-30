import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MainEvent {}

class BarSelected extends MainEvent {
  final int barIndex;

  BarSelected(this.barIndex);
}

class MainState {
  final int currentBar;

  MainState(this.currentBar);
}

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(0));

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is BarSelected) {
      yield MainState(event.barIndex);
    }
  }

  void selectBar(int barIndex) {
    add(BarSelected(barIndex));
  }
}
