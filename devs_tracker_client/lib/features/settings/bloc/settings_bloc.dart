import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class SettingsEvent {}

class ReloadEvent extends SettingsEvent {}

class SettingsState {
  final bool loaded;

  final SettingsData data;

  SettingsState.loading()
      : loaded = false,
        data = null;

  SettingsState.loaded(this.data)
      : loaded = true;
}

class SettingsData {
  final String version;

  SettingsData(this.version);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.loading()) {
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => reload());
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ReloadEvent) {
      yield SettingsState.loading();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version + "-" + packageInfo.buildNumber;
      yield SettingsState.loaded(SettingsData(version));
    }
  }

  void reload() {
    add(ReloadEvent());
  }

  void openPrivacyPolicy() {
    String privacyPolicyUrl = "https://devstracker.blogspot.com/2021/05/privacy-policy.html";
    print("Open url, $privacyPolicyUrl");
    launch(privacyPolicyUrl);
  }

  void openTermsAndConditions() {
    String termsAndConditionsUrl = "https://devstracker.blogspot.com/2021/05/terms-conditions.html";
    print("Open url, $termsAndConditionsUrl");
    launch(termsAndConditionsUrl);
  }
}
