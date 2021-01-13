class DeveloperApp {
  final int appleId;
  final String name;

  DeveloperApp(this.appleId, this.name);

  factory DeveloperApp.fromJson(Map<String, dynamic> json) {
    return DeveloperApp(json["appleId"], json["name"]);
  }

  @override
  String toString() {
    return "(appleId=${appleId}, name=\"${name}\")";
  }
}
