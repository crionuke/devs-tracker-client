import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class OfferingEvent {}

class PackageSelected extends OfferingEvent {
  final Package package;

  PackageSelected(this.package);
}

class OfferingState {
  final Package package;

  OfferingState(this.package);
}

class OfferingBloc extends Bloc<OfferingEvent, OfferingState> {
  OfferingBloc(Package selectedPackage) : super(OfferingState(selectedPackage));

  @override
  Stream<OfferingState> mapEventToState(OfferingEvent event) async* {
    if (event is PackageSelected) {
      yield OfferingState(event.package);
    }
  }

  void selectPackage(Package package) {
    add(PackageSelected(package));
  }
}
