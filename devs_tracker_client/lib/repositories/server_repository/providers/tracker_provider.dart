import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/error_response.dart';
import 'package:dio/dio.dart';

class TrackerProvider extends ApiProvider {
  TrackerProvider(String baseUrl) : super(baseUrl);

  Future<bool> track(String token, int developerAppleId) async {
    try {
      Response response = await dio.post("/" + developerAppleId.toString(),
          options: createRequestOptions(token));
      print("Got response from ${response.request.path}, "
          "statusCode=${response.statusCode}");
      return true;
    } on DioError catch (e) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(e.response.data);
      print("Got error from ${e.request.path}, " + errorResponse.message);
      return false;
    } catch (e) {
      print("Request failed, " + e);
      throw e;
    }
  }
}
