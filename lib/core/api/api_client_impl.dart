import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:startup_repo/imports.dart';
import 'error.dart';
import 'api_client.dart';

class ApiClientImpl extends GetxService implements ApiClient {
  final SharedPreferences prefs;
  final String baseUrl;
  final int timeoutInSeconds = 120;

  ApiClientImpl({required this.prefs, required this.baseUrl}) {
    token = prefs.getString(SharedKeys.token);
    updateHeader(token ?? '', prefs.getString(SharedKeys.languageCode));
  }

  http.Client? _client;
  Map<String, String> _mainHeaders = {"Content-Type": "application/json", 'Accept': 'application/json'};

  @override
  String? token;

  @override
  void updateHeader(String token, String? languageCode) {
    this.token = token;
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      SharedKeys.localizationKey: languageCode ?? appLanguages[0].languageCode,
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<void> cancelRequest() async {
    _client?.close();
    _client = null;
    debugPrint('====> API request canceled');
  }

  Future<http.Response?> _request(String method, String uri,
      {Map<String, dynamic>? body, Map<String, String>? headers, Map<String, String>? queryParams}) async {
    Uri url = Uri.parse('$baseUrl$uri').replace(queryParameters: queryParams);
    try {
      _printData(url.toString(), body: body);
      _client = http.Client();
      http.Response response;

      final requestHeaders = {..._mainHeaders, if (headers != null) ...headers};
      switch (method) {
        case 'GET':
          response = await _client!.get(url, headers: requestHeaders);
          break;
        case 'POST':
          response = await _client!.post(url, body: jsonEncode(body), headers: requestHeaders);
          break;
        case 'PUT':
          response = await _client!.put(url, body: jsonEncode(body), headers: requestHeaders);
          break;
        case 'DELETE':
          response = await _client!.delete(url, headers: requestHeaders);
          break;
        default:
          throw UnsupportedError("HTTP method not supported");
      }
      return await _handleResponse(response);
    } catch (e) {
      _socketException(e);
      return null;
    } finally {
      _client = null;
    }
  }

  @override
  Future<http.Response?> get(String uri, {Map<String, String>? headers, Map<String, String>? queryParams}) =>
      _request('GET', uri, headers: headers, queryParams: queryParams);

  @override
  Future<http.Response?> post(String uri, Map<String, dynamic> body, {Map<String, String>? headers}) =>
      _request('POST', uri, body: body, headers: headers);

  @override
  Future<http.Response?> put(String uri, Map<String, dynamic> body, {Map<String, String>? headers}) =>
      _request('PUT', uri, body: body, headers: headers);

  @override
  Future<http.Response?> delete(String uri, {Map<String, String>? headers}) =>
      _request('DELETE', uri, headers: headers);

  @override
  Future<Uint8List?> downloadImage(String uri) async {
    try {
      _printData(uri);
      final response =
          await http.get(Uri.parse(uri), headers: _mainHeaders).timeout(Duration(seconds: timeoutInSeconds));
      return response.statusCode == 200
          ? Uint8List.fromList(response.bodyBytes)
          : _handleError(jsonDecode(response.body));
    } catch (e) {
      _socketException(e);
      return null;
    }
  }

  void _printData(String url, {Map<String, dynamic>? body}) {
    debugPrint('====> API Call: $url, ====> Headers: $_mainHeaders');
    if (body != null) debugPrint('====> Body: $body');
  }

  Future<http.Response?> _handleResponse(http.Response response) async {
    hideLoading();
    return response.statusCode == 200 ? response : _handleError(jsonDecode(response.body));
  }

  dynamic _handleError(Map<String, dynamic> body) {
    if (body.containsKey('message')) {
      String message = body['message'];
      showToast(message);
      if (message == "Unauthenticated") {
        // logout
      }
    }
    ErrorResponse response = ErrorResponse.fromJson(body);
    showToast(response.errors.first.message);
    return null;
  }

  void _socketException(Object e) {
    if (e is SocketException) {
      showToast('Please check your internet connection');
    } else {
      showToast('Something went wrong');
    }
  }
}
