import 'package:dio/dio.dart';

enum ApiMethod {
  get('GET', showsErrorByDefault: false),
  head('HEAD', showsErrorByDefault: false),
  post('POST', showsErrorByDefault: true),
  put('PUT', showsErrorByDefault: true),
  patch('PATCH', showsErrorByDefault: true),
  delete('DELETE', showsErrorByDefault: true);

  const ApiMethod(this.value, {required this.showsErrorByDefault});

  final String value;
  final bool showsErrorByDefault;
}

enum ApiErrorFeedback {
  automatic,
  silent,
  toast;

  bool shouldShowFor(ApiMethod method) {
    return switch (this) {
      ApiErrorFeedback.automatic => method.showsErrorByDefault,
      ApiErrorFeedback.silent => false,
      ApiErrorFeedback.toast => true,
    };
  }
}

final class ApiRequest {
  const ApiRequest({
    required this.method,
    required this.path,
    this.query = const <String, Object?>{},
    this.data,
    this.headers = const <String, Object?>{},
    this.errorFeedback = ApiErrorFeedback.automatic,
    this.cancelToken,
  });

  final ApiMethod method;
  final String path;
  final Map<String, Object?> query;
  final Object? data;
  final Map<String, Object?> headers;
  final ApiErrorFeedback errorFeedback;
  final CancelToken? cancelToken;
}
