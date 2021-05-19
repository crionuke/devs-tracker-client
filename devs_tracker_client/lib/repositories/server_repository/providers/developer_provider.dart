import 'package:country_codes/country_codes.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/api_provider.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/developer_apps_response.dart';
import "package:dio/dio.dart";

import 'model/search_response.dart';

class DeveloperProvider extends ApiProvider {
  DeveloperProvider(String baseUrl) : super(baseUrl);

  Future<SearchResponse> search(
      String token, String device, String term) async {
    List<String> countries = ["us"];
    String deviceCountryCode =
        CountryCodes.getDeviceLocale().countryCode.toLowerCase();
    if (deviceCountryCode != "us") {
      countries.add(deviceCountryCode);
    }
    Response response = await dio.post("/search",
        options: createRequestOptions(token, device),
        data: {"term": term, "countries": countries});
    print(
        "${response.request.method} to ${response.request.uri}, ${response.data}");
    return SearchResponse.fromJson(response.data);
  }

  Future<DeveloperAppsResponse> getApps(
      String token, String device, int developerAppleId) async {
    Response response = await dio.get(
        "/" + developerAppleId.toString() + "/apps",
        options: createRequestOptions(token, device));
    print("${response.request.method} to ${response.request.uri}, "
        "statusCode=${response.statusCode}, ${response.data}");
    return DeveloperAppsResponse.fromJson(response.data);
  }
}
