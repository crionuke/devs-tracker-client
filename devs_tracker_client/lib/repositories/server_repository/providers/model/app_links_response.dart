import 'package:devs_tracker_client/repositories/server_repository/providers/model/app_link.dart';

class AppLinksResponse {
  final int count;
  final List<AppLink> links;

  AppLinksResponse(this.count, this.links);

  AppLinksResponse.empty()
      : count = 0,
        links = [];

  factory AppLinksResponse.fromJson(Map<String, dynamic> json) {
    List<AppLink> links =
        (json["links"] as List).map((link) => AppLink.fromJson(link)).toList();
    return AppLinksResponse(json["count"], links);
  }

  @override
  String toString() {
    return "count=$count, links=$links";
  }
}
