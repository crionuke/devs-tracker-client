class ParameterModel {
  static const TABLE = "parameters";

  static const ID_V1 = "p_id";
  static const KEY_V1 = "p_key";
  static const VALUE_V1 = "p_value";

  static const String createTableSql = "CREATE TABLE IF NOT EXISTS $TABLE ("
      "$ID_V1 INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "$KEY_V1 TEXT NOT NULL, "
      "$VALUE_V1 TEXT NOT NULL)";

  final int id;
  final String key;
  final String value;

  ParameterModel(this.id, this.key, this.value);

  factory ParameterModel.fromMap(Map<String, dynamic> map) =>
      ParameterModel(map[ID_V1], map[KEY_V1], map[VALUE_V1]);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (id != null) {
      map[ID_V1] = id;
    }

    map[KEY_V1] = key;
    map[VALUE_V1] = value;

    return map;
  }
}
