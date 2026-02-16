import 'dart:convert';

/// Pluggable error parser for API responses.
///
/// Different backends return errors in different formats. This class
/// provides a single entry point that tries multiple strategies in order.
/// Add new formats by adding a parser to [_parsers].
class ApiErrorParser {
  ApiErrorParser._();

  /// Extract a human-readable error message from an API response body.
  /// Returns `null` if the body can't be parsed.
  static String? parse(String responseBody) {
    try {
      final dynamic decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) return null;

      for (final parser in _parsers) {
        final String? message = parser(decoded);
        if (message != null && message.isNotEmpty) return message;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Ordered list of parsing strategies — first match wins.
  /// Add new backend formats here.
  static final List<String? Function(Map<String, dynamic>)> _parsers = [
    // Format: { "message": "Error text" }
    _parseMessage,

    // Format: { "error": "Error text" } or { "error": { "message": "..." } }
    _parseSingleError,

    // Format: { "errors": [{ "message": "..." }, ...] }
    _parseErrorsList,

    // Format: { "errors": { "field": ["msg1", "msg2"] } } (Laravel validation)
    _parseLaravelValidation,
  ];

  // ─── Parsers ───────────────────────────────────────────────

  static String? _parseMessage(Map<String, dynamic> body) {
    final dynamic message = body['message'];
    return message is String ? message : null;
  }

  static String? _parseSingleError(Map<String, dynamic> body) {
    final dynamic error = body['error'];
    if (error is String) return error;
    if (error is Map<String, dynamic>) {
      final dynamic msg = error['message'];
      return msg is String ? msg : null;
    }
    return null;
  }

  static String? _parseErrorsList(Map<String, dynamic> body) {
    final dynamic errors = body['errors'];
    if (errors is! List || errors.isEmpty) return null;
    final dynamic first = errors.first;
    if (first is String) return first;
    if (first is Map<String, dynamic>) {
      final dynamic msg = first['message'];
      return msg is String ? msg : null;
    }
    return null;
  }

  static String? _parseLaravelValidation(Map<String, dynamic> body) {
    final dynamic errors = body['errors'];
    if (errors is! Map<String, dynamic> || errors.isEmpty) return null;
    final dynamic firstField = errors.values.first;
    if (firstField is List && firstField.isNotEmpty) {
      return firstField.first.toString();
    }
    return null;
  }
}
