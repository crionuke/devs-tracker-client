import 'developer_model.dart';

class SearchResponseModel {
  final int count;
  final List<DeveloperModel> developers;

  SearchResponseModel(this.count, this.developers);

  SearchResponseModel.empty()
      : count = 0,
        developers = List();

  SearchResponseModel.fromJson(Map<String, dynamic> json)
      : count = json["count"],
        developers = (json["developers"] as List)
            .map((developer) => DeveloperModel.fromJson(developer))
            .toList();
}
