class AppLink {
  final String title;
  final String country;

  AppLink(this.title, this.country);

  factory AppLink.fromJson(Map<String, dynamic> json) {
    return AppLink(json["title"], json["country"]);
  }

  @override
  String toString() {
    return "(title=${title}, country=${country})";
  }
}
