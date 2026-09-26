import 'package:dio/dio.dart';

import '../model/api_failure.dart';
import '../model/api_request.dart';
import '../model/api_result.dart';
import '../support/api_failure_mapper.dart';
import 'api_client.dart';

typedef ApiFeedbackHandler = void Function(ApiFailure failure);

final class DioApiClient implements ApiClient {
  DioApiClient({required String baseUrl, required this.feedbackHandler, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: _defaultTimeout,
              sendTimeout: _defaultTimeout,
              receiveTimeout: _defaultTimeout,
              contentType: Headers.jsonContentType,
              headers: const <String, Object?>{'Accept': Headers.jsonContentType},
            ),
          );

  static const Duration _defaultTimeout = Duration(seconds: 30);

  final Dio _dio;
  final ApiFeedbackHandler feedbackHandler;

  @override
  Future<ApiResult<Object?>> execute(ApiRequest request) async {
    try {
      final Response<Object?> response = await _dio.request<Object?>(
        request.path,
        data: request.data,
        queryParameters: request.query,
        cancelToken: request.cancelToken,
        options: Options(
          method: request.method.value,
          headers: request.headers,
          validateStatus: (int? _) => true,
        ),
      );
      return _resultFrom(request, response);
    } on DioException catch (exception) {
      return _failure(request, ApiFailureMapper.fromException(exception));
    } on Object {
      return _failure(request, const ApiFailure(kind: ApiFailureKind.unknown));
    }
  }

  ApiResult<Object?> _resultFrom(ApiRequest request, Response<Object?> response) {
    final int statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode >= 300) {
      return _failure(request, ApiFailureMapper.fromResponse(response));
    }

    return Success<Object?>(response.data, statusCode: statusCode, headers: response.headers.map);
  }

  Failure<Object?> _failure(ApiRequest request, ApiFailure failure) {
    final bool shouldShow = request.errorFeedback.shouldShowFor(request.method);
    if (shouldShow && failure.kind != ApiFailureKind.cancelled) {
      feedbackHandler(failure);
    }
    return Failure<Object?>(failure);
  }

  @override
  void updateHeader(String name, Object? value) {
    if (value == null) {
      _dio.options.headers.remove(name);
      return;
    }
    _dio.options.headers[name] = value;
  }

  @override
  void close() => _dio.close(force: true);
}
