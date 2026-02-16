import 'dart:convert';
import 'dart:io';
import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/language/data/model/language.dart';
import 'package:startup_repo/core/helper/connectivity.dart';
import 'package:startup_repo/core/api/api_result.dart';
import 'package:startup_repo/core/api/api_client.dart';
import 'package:startup_repo/core/api/error.dart';

class ApiClientImpl extends GetxService implements ApiClient {
  final SharedPreferences prefs;
  final String baseUrl;
  final int timeoutInSeconds = 120;

  ApiClientImpl({required this.prefs, required this.baseUrl}) {
    token = prefs.getString(SharedKeys.token);
    updateHeader(token ?? '', prefs.getString(SharedKeys.languageCode));
  }

  Client? _client;
  Map<String, String> _mainHeaders = {'Content-Type': 'application/json', 'Accept': 'application/json'};

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

  Future<ApiResult<Response>> _request(
    String method,
    String uri, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    if (!await ConnectivityService.isConnected()) {
      ConnectivityService.showOfflineDialog();
      return const Failure('No internet connection');
    }

    final Uri url = Uri.parse('$baseUrl$uri').replace(queryParameters: queryParams);
    try {
      _printData(url.toString(), body: body);
      _client = Client();
      Response response;

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
          throw UnsupportedError('HTTP method not supported');
      }
      return _handleResponse(response);
    } catch (e) {
      return _handleException<Response>(e);
    } finally {
      _client = null;
    }
  }

  @override
  Future<ApiResult<Response>> get(
    String uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) =>
      _request('GET', uri, headers: headers, queryParams: queryParams);

  @override
  Future<ApiResult<Response>> post(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) =>
      _request('POST', uri, body: body, headers: headers);

  @override
  Future<ApiResult<Response>> put(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) =>
      _request('PUT', uri, body: body, headers: headers);

  @override
  Future<ApiResult<Response>> delete(
    String uri, {
    Map<String, String>? headers,
  }) =>
      _request('DELETE', uri, headers: headers);

  void _printData(String url, {Map<String, dynamic>? body}) {
    debugPrint('====> API Call: $url, ====> Headers: $_mainHeaders');
    if (body != null) debugPrint('====> Body: $body');
  }

  ApiResult<Response> _handleResponse(Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Success(response);
    }
    return _handleError(response);
  }

  Failure<Response> _handleError(Response response) {
    final String message = ApiErrorParser.parse(response.body) ?? 'Something went wrong';
    AppDialog.showToast(message);

    if (message == 'Unauthenticated') {
      // TODO: logout
    }

    return Failure(message, statusCode: response.statusCode);
  }

  Failure<T> _handleException<T>(Object e) {
    if (e is SocketException) {
      const String message = 'Please check your internet connection';
      AppDialog.showToast(message);
      return const Failure(message);
    } else {
      const String message = 'Something went wrong';
      AppDialog.showToast(message);
      return Failure(message);
    }
  }
}
