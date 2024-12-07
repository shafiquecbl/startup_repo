import 'dart:typed_data';
import 'package:http/http.dart';

abstract class ApiClientInterface {
  Future<void> cancelRequest();

  Future<Response?> get(
    String uri, {
    Map<String, String>? headers,
  });

  Future<Response?> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  });

  Future<Response?> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  });

  Future<Response?> delete(
    String url, {
    Map<String, String>? headers,
  });

  Future<Uint8List?> downloadImage(String uri);
}
