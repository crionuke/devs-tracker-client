import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/app_response.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/error_response.dart';
import 'package:dio/dio.dart';

class AppProvider extends ApiProvider {
  AppProvider(String baseUrl) : super(baseUrl);

  Future<AppResponse> get(String token, int appAppled) async {
    try {
      Response response = await dio.get("/" + appAppled.toString(),
          options: createRequestOptions(token));
      print("${response.request.method} to ${response.request.uri}, "
          "statusCode=${response.statusCode}");
      return AppResponse.fromJson(response.data);
    } on DioError catch (e) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(e.response.data);
      print(
          "Got error from from ${e.response.request.method}:${e.response.request.uri}, " +
              errorResponse.message);
      return AppResponse.empty();
    } catch (e) {
      print("Request failed, " + e);
      throw e;
    }
  }
}
