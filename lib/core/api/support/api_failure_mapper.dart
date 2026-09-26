import 'package:dio/dio.dart';

import '../model/api_failure.dart';
import 'api_error_parser.dart';

class ApiFailureMapper {
  ApiFailureMapper._();

  static ApiFailure fromResponse(Response<Object?> response) {
    final int statusCode = response.statusCode ?? 0;
    final ApiErrorDetails details = ApiErrorParser.parse(response.data);
    final ApiFailureKind kind = switch (statusCode) {
      400 || 422 => ApiFailureKind.validation,
      401 => ApiFailureKind.unauthenticated,
      403 => ApiFailureKind.forbidden,
      404 => ApiFailureKind.notFound,
      429 => ApiFailureKind.rateLimited,
      >= 500 => ApiFailureKind.server,
      _ => ApiFailureKind.unknown,
    };

    return ApiFailure(
      kind: kind,
      serverMessage: details.message,
      statusCode: statusCode,
      code: details.code,
      fieldErrors: details.fieldErrors,
      traceId: _traceId(response.headers),
    );
  }

  static ApiFailure fromException(DioException exception) {
    final Response<Object?>? response = exception.response;
    if (response != null) {
      return fromResponse(response);
    }

    return switch (exception.type) {
      DioExceptionType.cancel => const ApiFailure(kind: ApiFailureKind.cancelled),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const ApiFailure(kind: ApiFailureKind.timeout),
      DioExceptionType.connectionError => const ApiFailure(kind: ApiFailureKind.network),
      _ => const ApiFailure(kind: ApiFailureKind.unknown),
    };
  }

  static String? _traceId(Headers headers) {
    return headers.value('x-request-id') ?? headers.value('x-correlation-id') ?? headers.value('trace-id');
  }
}
