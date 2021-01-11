class SearchDeveloper {
  final int appleId;
  final String name;

  SearchDeveloper(this.appleId, this.name);

  factory SearchDeveloper.fromJson(Map<String, dynamic> json) {
    return SearchDeveloper(json["appleId"], json["name"]);
  }
}
