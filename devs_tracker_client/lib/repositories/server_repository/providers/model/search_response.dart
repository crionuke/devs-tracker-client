import 'search_developer.dart';

class SearchResponse {
  final int count;
  final List<SearchDeveloper> developers;

  SearchResponse(this.count, this.developers);

  SearchResponse.empty()
      : count = 0,
        developers = List();

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    List<SearchDeveloper> developers = (json["developers"] as List)
        .map((developer) => SearchDeveloper.fromJson(developer))
        .toList();
    return SearchResponse(json["count"], developers);
  }
}
