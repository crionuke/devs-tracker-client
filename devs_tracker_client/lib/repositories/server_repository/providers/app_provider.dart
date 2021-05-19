import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/app_links_response.dart';
import "package:dio/dio.dart";

class AppProvider extends ApiProvider {
  AppProvider(String baseUrl) : super(baseUrl);

  Future<AppLinksResponse> getLinks(
      String token, String device, int appAppleId) async {
    Response response = await dio.get("/" + appAppleId.toString() + "/links",
        options: createRequestOptions(token, device));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}, ${response.data}");
    return AppLinksResponse.fromJson(response.data);
  }
}
