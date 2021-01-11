import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/error_response.dart';
import "package:dio/dio.dart";

import 'model/search_response.dart';

class DeveloperProvider extends ApiProvider {
  DeveloperProvider(String baseUrl) : super(baseUrl);

  Future<SearchResponse> search(String token, String term) async {
    try {
      Response response = await dio.post("/search",
          options: RequestOptions(
              baseUrl: baseUrl,
              connectTimeout: 3000,
              receiveTimeout: 5000,
              receiveDataWhenStatusError: true,
              validateStatus: (status) => status >= 200 && status < 300,
              headers: {"Authorization": "Bearer " + token}),
          data: {
            "term": term,
            "countries": ["ru", "us"]
          });
      print("Got response from ${response.request.path}, " +
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
}
