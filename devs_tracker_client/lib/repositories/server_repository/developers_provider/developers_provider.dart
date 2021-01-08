import "package:dio/dio.dart";

import 'model/search_response.dart';

class DevelopersProvider {
  final String endpoint;
  final Dio dio;

  DevelopersProvider(this.endpoint) : dio = Dio();

  Future<SearchResponseModel> search(String term) async {
    try {
      Response response = await dio.post(endpoint + "/search", data: {
        "term": term,
        "countries": ["ru", "us"],
      });
      return SearchResponseModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SearchResponseModel.empty();
    }
  }
}
