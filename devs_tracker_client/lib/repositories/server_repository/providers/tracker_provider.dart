import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_response.dart';
import 'package:dio/dio.dart';

class TrackerProvider extends ApiProvider {
  TrackerProvider(String baseUrl) : super(baseUrl);

  Future<TrackedResponse> get(String token) async {
    Response response = await dio.get("/",
        options: createRequestOptions(token));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}");
    return TrackedResponse.fromJson(response.data);
  }

  Future<void> post(String token, int developerAppleId) async {
    Response response = await dio.post("/" + developerAppleId.toString(),
        options: createRequestOptions(token));
    print("${response.request.method} to ${response.request.uri} finished "
        "statusCode=${response.statusCode}");
  }

  Future<void> delete(String token, int developerAppleId) async {
    Response response = await dio.delete("/" + developerAppleId.toString(),
        options: createRequestOptions(token));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}");
  }
}
