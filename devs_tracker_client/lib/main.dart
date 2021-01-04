import 'package:db_repository/db_repository.dart';
import 'package:devs_tracker_client/app.dart';
import 'package:flutter/material.dart';
import 'package:purchase_repository/purchase_repository.dart';

void main() {
  runApp(App(DbRepository(), PurchaseRepository()));
}
