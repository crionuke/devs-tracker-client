import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

enum PushRepositoryStatus { loading, loaded }

class PushRepository {
  final StreamController controller;
  final FirebaseMessaging messaging;

  PushRepository()
      : controller = StreamController<PushRepositoryStatus>(),
        messaging = FirebaseMessaging.instance;

  Stream<PushRepositoryStatus> get status async* {
    yield PushRepositoryStatus.loading;
    await requestPermission();
    String deviceToken = await getDeviceToken();
    print("DeviceToken=$deviceToken");
    messaging.onTokenRefresh.listen((event) { });
    yield PushRepositoryStatus.loaded;
  }

  void dispose() => controller.close();

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  Future<String> getDeviceToken() async {
    return messaging.getToken();
  }
}
