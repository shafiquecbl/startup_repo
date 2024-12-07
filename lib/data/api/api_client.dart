import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import '../../view/base/common/snackbar.dart';
import '../model/response/error.dart';
import 'api_client_interface.dart';

class ApiClient extends GetxService implements ApiClientInterface {
  final SharedPreferences sharedPreferences;
  final String baseUrl;
  ApiClient({required this.sharedPreferences, required this.baseUrl});

  final int timeoutInSeconds = 120;
  http.Client? _client; // Track the client for cancellation

  final Map<String, String> _mainHeaders = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
  };

  @override
  Future<void> cancelRequest() async {
    if (_client != null) {
      _client!.close(); // Cancel the ongoing request
      _client = null; // Reset the client
      debugPrint('====> API request canceled');
    }
  }

  @override
  Future<http.Response?> get(String uri, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!
          .get(url, headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<http.Response?> post(
    String uri,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  }) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');
      debugPrint('====> Body: $body');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!.post(
        url,
        body: jsonEncode(body),
        headers: {
          ..._mainHeaders,
          if (headers != null) ...headers,
        },
      ).timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<http.Response?> put(
    String uri,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  }) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');
      debugPrint('====> Body: $body');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!.put(
        url,
        body: jsonEncode(body),
        headers: {
          ..._mainHeaders,
          if (headers != null) ...headers,
        },
      ).timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<http.Response?> delete(String uri, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!
          .delete(url, headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<Uint8List?> downloadImage(String uri) async {
    try {
      // print the api call
      debugPrint('====> API Call: $uri, ====> Header: $_mainHeaders');

      http.Response response = await http
          .get(
            Uri.parse(uri),
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode != 200) {
        return _handleError(jsonDecode(response.body));
      } else {
        hideLoading();
        return Uint8List.fromList(response.bodyBytes);
      }
    } catch (e) {
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  Future<http.Response?> _handleResponse(http.Response response) async {
    if (response.statusCode != 200) {
      return _handleError(jsonDecode(response.body));
    } else {
      hideLoading();
      return response;
    }
  }

  _handleError(Map<String, dynamic> body) {
    if (body.containsKey('message')) {
      showToast(body['message']);
      return null;
    }
    ErrorResponse response = ErrorResponse.fromJson(body);
    hideLoading();
    showToast(response.errors.first.message);
    return null;
  }

  _socketException(Object e) {
    if (e is SocketException) {
      showToast('Please check your internet connection');
    } else {
      if (e is http.ClientException) {
        if (e.message != 'Connection closed before full header was received') {
          showToast('Something went wrong');
        }
      } else {
        showToast('Something went wrong');
      }
    }
  }
}
