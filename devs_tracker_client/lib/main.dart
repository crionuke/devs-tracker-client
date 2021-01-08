import 'package:devs_tracker_client/app.dart';
import 'package:devs_tracker_client/repositories/db_repository/db_repository.dart';
import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter/material.dart';

const BASE_URL = "http://localhost:8080/devstracker/v1";

void main() {
  runApp(App(DbRepository(), PurchaseRepository(), ServerRepository(BASE_URL)));
}
