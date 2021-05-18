import 'package:dio/dio.dart';

abstract class ApiProvider {
  final String baseUrl;
  final Dio dio;

  ApiProvider(this.baseUrl) : dio = Dio();

  RequestOptions createRequestOptions(String token, String device) {
    return RequestOptions(
        baseUrl: baseUrl,
        connectTimeout: 5000,
        receiveTimeout: 5000,
        receiveDataWhenStatusError: true,
        validateStatus: (status) => status >= 200 && status < 300,
        headers: {
          "Authorization": "Bearer " + token,
          "Device": device,
          "Sign": getSign(token, device)
        });
  }

  int getSign(String token, String device) {
    int result = 0;
    int len1 = token.length;
    int len2 = device.length;
    token.runes.forEach((int rune) {
      result += rune + len1;
    });
    device.runes.forEach((int rune) {
      result += rune + len2;
    });
    return result * result;
  }
}
