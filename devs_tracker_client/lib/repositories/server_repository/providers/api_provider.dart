import 'package:dio/dio.dart';

abstract class ApiProvider {
  final String baseUrl;
  final Dio dio;

  ApiProvider(this.baseUrl) : dio = Dio();

  RequestOptions createRequestOptions(String token) {
    return RequestOptions(
        baseUrl: baseUrl,
        connectTimeout: 3000,
        receiveTimeout: 5000,
        receiveDataWhenStatusError: true,
        validateStatus: (status) =>
        status >= 200 && status < 300,
        headers: {"Authorization": "Bearer " + token});
  }
}
