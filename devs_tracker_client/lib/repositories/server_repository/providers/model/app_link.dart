class AppLink {
  final String title;
  final String country;
  final String url;

  AppLink(this.title, this.country, this.url);

  factory AppLink.fromJson(Map<String, dynamic> json) {
    return AppLink(json["title"], json["country"], json["url"]);
  }

  @override
  String toString() {
    return "(title=\"${title}\", country=${country}, url=\"${url}\")";
  }
}
