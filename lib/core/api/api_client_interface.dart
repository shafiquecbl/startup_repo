import 'dart:typed_data';
import 'package:http/http.dart';

abstract class ApiClientInterface {
  String? token;

  void updateHeader(String token, String languageCode);

  Future<void> cancelRequest();

  Future<Response?> get(String uri, {Map<String, String>? headers, Map<String, String>? queryParams});

  Future<Response?> post(String url, Map<String, dynamic> body, {Map<String, String>? headers});

  Future<Response?> put(String url, Map<String, dynamic> body, {Map<String, String>? headers});

  Future<Response?> delete(String url, {Map<String, String>? headers});

  Future<Uint8List?> downloadImage(String uri);
}
