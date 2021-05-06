import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_apps_response.dart';
import "package:dio/dio.dart";

import 'model/search_response.dart';

class DeveloperProvider extends ApiProvider {
  DeveloperProvider(String baseUrl) : super(baseUrl);

  Future<SearchResponse> search(
      String token, String device, String term) async {
    Response response = await dio
        .post("/search", options: createRequestOptions(token, device), data: {
      "term": term,
      "countries": ["ru", "us"]
    });
    print("${response.request.method} to ${response.request.uri}, " +
        response.data.toString());
    return SearchResponse.fromJson(response.data);
  }

  Future<DeveloperAppsResponse> getApps(
      String token, String device, int developerAppleId) async {
    Response response = await dio.get(
        "/" + developerAppleId.toString() + "/apps",
        options: createRequestOptions(token, device));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}");
    return DeveloperAppsResponse.fromJson(response.data);
  }
}
