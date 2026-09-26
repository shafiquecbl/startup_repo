import '../model/api_request.dart';
import '../model/api_result.dart';

abstract interface class ApiClient {
  Future<ApiResult<Object?>> execute(ApiRequest request);

  void updateHeader(String name, Object? value);

  void close();
}
