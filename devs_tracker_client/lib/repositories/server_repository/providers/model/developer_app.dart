import 'package:devs_tracker_client/repositories/server_repository/providers/model/app_link.dart';

class DeveloperApp {
  final int appleId;
  final DateTime releaseDate;
  final Map<String, AppLink> links;

  DeveloperApp(this.appleId, String releaseDateString, this.links)
      :
        releaseDate = DateTime.parse(releaseDateString);

  factory DeveloperApp.fromJson(Map <String, dynamic> json) {
    Map<String, AppLink> links = Map();
    (json["links"] as List)
        .map((link) => AppLink.fromJson(link))
        .forEach((link) => links[link.country] = link);

    return DeveloperApp(
        json["appleId"], json["releaseDate"], links);
  }

  @override
  String toString() {
    return "(appleId=${appleId}, appleId=${releaseDate}, link=${links})";
  }

  String get title {
    if (links.isEmpty) {
      return "<Unknown>";
    } else {
      if (links.containsKey("ru")) {
        return links["ru"].title;
      } else if (links.containsKey("us")) {
        return links["us"].title;
      } else {
        return links.values.toList()[0].title;
      }
    }
  }
}
