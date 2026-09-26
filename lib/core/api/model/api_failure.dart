enum ApiFailureKind {
  network,
  timeout,
  cancelled,
  unauthenticated,
  forbidden,
  notFound,
  validation,
  rateLimited,
  server,
  unknown;

  String get translationKey => switch (this) {
    ApiFailureKind.network => 'api_error_network',
    ApiFailureKind.timeout => 'api_error_timeout',
    ApiFailureKind.cancelled => 'api_error_cancelled',
    ApiFailureKind.unauthenticated => 'api_error_unauthenticated',
    ApiFailureKind.forbidden => 'api_error_forbidden',
    ApiFailureKind.notFound => 'api_error_not_found',
    ApiFailureKind.validation => 'api_error_validation',
    ApiFailureKind.rateLimited => 'api_error_rate_limited',
    ApiFailureKind.server => 'api_error_server',
    ApiFailureKind.unknown => 'api_error_unknown',
  };
}

final class ApiFailure {
  const ApiFailure({
    required this.kind,
    this.serverMessage,
    this.statusCode,
    this.code,
    this.fieldErrors = const <String, List<String>>{},
    this.traceId,
  });

  final ApiFailureKind kind;
  final String? serverMessage;
  final int? statusCode;
  final String? code;
  final Map<String, List<String>> fieldErrors;
  final String? traceId;
}
