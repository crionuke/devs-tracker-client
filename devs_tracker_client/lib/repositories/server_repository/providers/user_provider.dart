import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import "package:dio/dio.dart";

class UserProvider extends ApiProvider {
  UserProvider(String baseUrl) : super(baseUrl);

  Future<void> signIn(String token, String device) async {
    Response response =
        await dio.post("/signIn", options: createRequestOptions(token, device));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}, ${response.data}");
  }
}
