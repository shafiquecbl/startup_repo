import 'package:http/http.dart';
import 'api_result.dart';

abstract class ApiClient {
  String? token;

  void updateHeader(String token, String languageCode);

  Future<void> cancelRequest();

  Future<ApiResult<Response>> get(
    String uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  Future<ApiResult<Response>> post(String url, Map<String, dynamic> body, {Map<String, String>? headers});

  Future<ApiResult<Response>> put(String url, Map<String, dynamic> body, {Map<String, String>? headers});

  Future<ApiResult<Response>> delete(String url, {Map<String, String>? headers});
}
