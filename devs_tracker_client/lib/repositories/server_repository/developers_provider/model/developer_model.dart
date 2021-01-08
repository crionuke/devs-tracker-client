class DeveloperModel {
  final int id;
  final String name;

  DeveloperModel(this.id, this.name);

  DeveloperModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
