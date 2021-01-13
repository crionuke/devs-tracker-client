class TrackedDeveloper {
  final int added;
  final int appleId;
  final String name;

  TrackedDeveloper(this.added, this.appleId, this.name);

  factory TrackedDeveloper.fromJson(Map<String, dynamic> json) {
    return TrackedDeveloper(json["added"], json["appleId"], json["name"]);
  }
}
