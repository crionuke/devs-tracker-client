import 'dart:async';

import 'package:devs_tracker_client/repositories/db_repository/model/parameter_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum DbRepositoryStatus { loading, loaded }

class DbRepository {
  // UNCOMMENT THIS BEFORE RELEASE!
  //  static const String DATABASE_NAME = "devstracker.db";
  // COMMENT THIS BEFORE RELEASE!
  static const String DATABASE_NAME = "devstracker_004.db";

  final _controller = StreamController<DbRepositoryStatus>();

  Database database;

  Stream<DbRepositoryStatus> get status async* {
    yield DbRepositoryStatus.loading;
    String path = join(await getDatabasesPath(), DATABASE_NAME);
    database =
    await openDatabase(path, version: 1,
        onConfigure: (database) async {
          await database.execute("PRAGMA foreign_keys = ON");
        },
        onOpen: (database) async {
          database = database;
          print("Database $DATABASE_NAME opened");
        },
        onCreate: (database, version) async {
          // Version 1 - initial
          if (version >= 1) {
            print(ParameterModel.createTableSql);
            await database.execute(ParameterModel.createTableSql);
          }
          print("Database $DATABASE_NAME with version $version created");
        });

    yield DbRepositoryStatus.loaded;
  }

  void dispose() => _controller.close();

  // Parameter CRUD operations

  Future<int> addP(ParameterModel model) async {
    return database.insert(ParameterModel.TABLE, model.toMap());
  }

  Future<void> editP(String key, ParameterModel model) async {
    database.update(ParameterModel.TABLE, model.toMap(),
        where: '${ParameterModel.KEY_V1}=?', whereArgs: [key]);
  }

  Future<void> deleteP(String key) async {
    database.delete(ParameterModel.TABLE,
        where: '${ParameterModel.KEY_V1}=?', whereArgs: [key]);
  }

  Future<Map<String, String>> getAllP() async {
    List<Map<String, dynamic>> results =
    await database.query(ParameterModel.TABLE);
    Map<String, String> map = {};
    results.forEach((value) =>
    map[value[ParameterModel.KEY_V1]] = value[ParameterModel.VALUE_V1]);
    return map;
  }
}