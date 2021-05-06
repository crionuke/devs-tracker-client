import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/tracked_response.dart';
import 'package:dio/dio.dart';

class TrackerProvider extends ApiProvider {
  TrackerProvider(String baseUrl) : super(baseUrl);

  Future<TrackedResponse> get(String token, String device) async {
    Response response = await dio.get("/",
        options: createRequestOptions(token, device));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}");
    return TrackedResponse.fromJson(response.data);
  }

  Future<void> post(String token, String device, int developerAppleId) async {
    Response response = await dio.post("/" + developerAppleId.toString(),
        options: createRequestOptions(token, device));
    print("${response.request.method} to ${response.request.uri} finished "
        "statusCode=${response.statusCode}");
  }

  Future<void> delete(String token, String device, int developerAppleId) async {
    Response response = await dio.delete("/" + developerAppleId.toString(),
        options: createRequestOptions(token, device));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}");
  }
}
