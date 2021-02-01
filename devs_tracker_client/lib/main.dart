import 'package:devs_tracker_client/app.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter/material.dart';

// static const String DATABASE_NAME = "devstracker.db";
const String DATABASE_NAME = "devstracker_004.db";

//const String BASE_URL = "http://localhost:8080/devstracker/v1";
const String BASE_URL = "http://192.168.1.65:8080/devstracker/v1";

void main() {
  runApp(App(DbRepository(DATABASE_NAME), PurchaseRepository(),
      ServerRepository(BASE_URL)));
}
