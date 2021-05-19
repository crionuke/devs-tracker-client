import 'package:country_codes/country_codes.dart';
import 'package:devs_tracker_client/app.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// static const String DATABASE_NAME = "devstracker.db";
const String DATABASE_NAME = "devstracker_004.db";

//const String BASE_URL = "http://localhost:10000/devstracker/v1";
const String BASE_URL = "https://devstracker.crionuke.com/devstracker/v1";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CountryCodes.init();
  runApp(App(DbRepository(DATABASE_NAME), PurchaseRepository(),
      ServerRepository(BASE_URL), PushRepository()));
}
