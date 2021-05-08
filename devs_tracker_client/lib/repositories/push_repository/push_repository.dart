import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

enum PushRepositoryStatus { loading, loaded }

class PushRepository {
  final StreamController controller;
  final FirebaseMessaging messaging;

  String _deviceToken;

  PushRepository()
      : controller = StreamController<PushRepositoryStatus>(),
        messaging = FirebaseMessaging.instance;

  Stream<PushRepositoryStatus> get status async* {
    yield PushRepositoryStatus.loading;
    await requestPermission();
    await handleInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print("Got remote message: $remoteMessage");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      print("Got message opened app: $remoteMessage");
    });

    _deviceToken = await requestDeviceToken();
    print("DeviceToken=$_deviceToken");
    yield PushRepositoryStatus.loaded;
  }

  void dispose() => controller.close();

  String getDeviceToken() => _deviceToken;

  Future<void> handleInitialMessage() async {
    await messaging.getInitialMessage().then((remoteMessage) {
      if (remoteMessage != null) {
        print("Started with remote message: $remoteMessage");
      }
    });
  }

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

  Future<String> requestDeviceToken() async {
    return messaging.getToken();
  }
}
