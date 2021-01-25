import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_apps_response.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/error_response.dart';
import "package:dio/dio.dart";

import 'model/search_response.dart';

class DeveloperProvider extends ApiProvider {
  DeveloperProvider(String baseUrl) : super(baseUrl);

  Future<SearchResponse> search(String token, String term) async {
    try {
      Response response = await dio.post("/search",
          options: createRequestOptions(token),
          data: {
            "term": term,
            "countries": ["ru", "us"]
          });
      print("${response.request.method} to ${response.request.uri}, " +
          response.data.toString());
      return SearchResponse.fromJson(response.data);
    } on DioError catch (e) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(e.response.data);
      print("Got error from ${e.request.path}, " + errorResponse.message);
      return SearchResponse.empty();
    } catch (e) {
      print("Request failed, " + e);
      throw e;
    }
  }

  Future<DeveloperAppsResponse> getApps(String token, int developerAppleId) async {
    Response response = await dio.get(
        "/" + developerAppleId.toString() + "/apps",
        options: createRequestOptions(token));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}");
    return DeveloperAppsResponse.fromJson(response.data);
  }
}
