/// A sealed class representing the result of an API call.
///
/// Use pattern matching to handle success and failure cases:
/// ```dart
/// final result = await service.getData();
/// if (result case Success(data: final data)) {
///   // use data
/// }
/// // Failure? Toast was already shown by API client.
/// ```
sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  const Failure(this.message, {this.statusCode});
}
