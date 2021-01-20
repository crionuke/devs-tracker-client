class AppResponse {
  final List<String> countries;

  AppResponse(this.countries);

  AppResponse.empty() : countries = List();

  factory AppResponse.fromJson(Map<String, dynamic> json) {
    List<String> countries = List.from(json["countries"]);
    return AppResponse(countries);
  }

  @override
  String toString() {
    return "countries=$countries";
  }
}
