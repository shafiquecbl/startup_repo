import 'api_failure.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data, {required this.statusCode, this.headers = const <String, List<String>>{}});

  final T data;
  final int statusCode;
  final Map<String, List<String>> headers;
}

final class Failure<T> extends ApiResult<T> {
  const Failure(this.error);

  final ApiFailure error;

  int? get statusCode => error.statusCode;
}
