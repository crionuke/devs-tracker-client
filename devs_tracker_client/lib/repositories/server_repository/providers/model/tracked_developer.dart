class TrackedDeveloper {
  final DateTime added;
  final int appleId;
  final String name;
  final int count;

  TrackedDeveloper(String addedString, this.appleId, this.name, this.count) :
        added = DateTime.parse(addedString);

  factory TrackedDeveloper.fromJson(Map<String, dynamic> json) {
    return TrackedDeveloper(
        json["added"], json["appleId"], json["name"], json["count"]);
  }

  @override
  String toString() {
    return "(added=\"$added\", appleId=$appleId, name=\"$name\", count=$count)";
  }
}
