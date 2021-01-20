class DeveloperApp {
  final int appleId;
  final DateTime releaseDate;
  final String title;

  DeveloperApp(this.appleId, String releaseDateString, this.title) :
        releaseDate = DateTime.parse(releaseDateString);

  factory DeveloperApp.fromJson(Map<String, dynamic> json) {
    return DeveloperApp(json["appleId"], json["releaseDate"], json["title"]);
  }

  @override
  String toString() {
    return "(appleId=${appleId}, appleId=${releaseDate}, name=\"${title}\")";
  }
}
