import 'dart:convert';

final class ApiErrorDetails {
  const ApiErrorDetails({this.message, this.code, this.fieldErrors = const <String, List<String>>{}});

  final String? message;
  final String? code;
  final Map<String, List<String>> fieldErrors;
}

class ApiErrorParser {
  ApiErrorParser._();

  static ApiErrorDetails parse(Object? responseData) {
    final Map<String, Object?>? body = _asMap(responseData);
    if (body == null) {
      return const ApiErrorDetails();
    }

    final Object? nestedError = body['error'];
    final Map<String, Object?>? nestedErrorMap = _asMap(nestedError);
    return ApiErrorDetails(
      message: _string(body['message']) ?? _string(nestedError) ?? _string(nestedErrorMap?['message']),
      code: _string(body['code']) ?? _string(nestedErrorMap?['code']),
      fieldErrors: _fieldErrors(body['errors']),
    );
  }

  static Map<String, Object?>? _asMap(Object? value) {
    Object? decoded = value;
    if (value is String && value.trim().isNotEmpty) {
      try {
        decoded = jsonDecode(value);
      } on FormatException {
        return null;
      }
    }
    if (decoded is! Map) {
      return null;
    }
    return decoded.map((Object? key, Object? item) => MapEntry<String, Object?>(key.toString(), item));
  }

  static Map<String, List<String>> _fieldErrors(Object? value) {
    final Map<String, Object?>? errors = _asMap(value);
    if (errors == null) {
      return const <String, List<String>>{};
    }
    return errors.map((String key, Object? item) {
      final List<String> messages = switch (item) {
        final List<Object?> values => values.map((Object? message) => message.toString()).toList(),
        null => const <String>[],
        _ => <String>[item.toString()],
      };
      return MapEntry<String, List<String>>(key, messages);
    });
  }

  static String? _string(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}
