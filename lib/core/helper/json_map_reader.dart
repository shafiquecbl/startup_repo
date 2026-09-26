import 'dart:convert';

Map<String, dynamic> readJsonMap(Object? value) {
  final Object? decoded = value is String ? jsonDecode(value) : value;
  if (decoded is Map<Object?, Object?>) {
    return Map<String, dynamic>.from(decoded);
  }
  throw const FormatException('Expected a JSON object.');
}

extension JsonMapReader on Map<String, dynamic> {
  String requiredString(String key) {
    final Object? value = this[key];
    if (value is String) {
      return value;
    }
    throw FormatException('Expected "$key" to be a string.');
  }

  String? optionalString(String key) {
    final Object? value = this[key];
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    throw FormatException('Expected "$key" to be a string or null.');
  }

  bool boolean(String key, {bool fallback = false}) {
    final Object? value = this[key];
    if (value == null) {
      return fallback;
    }
    if (value is bool) {
      return value;
    }
    throw FormatException('Expected "$key" to be a boolean.');
  }

  int integer(String key, {int? fallback}) {
    final Object? value = this[key];
    if (value == null && fallback != null) {
      return fallback;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    throw FormatException('Expected "$key" to be an integer.');
  }

  double decimal(String key, {double? fallback}) {
    final Object? value = this[key];
    if (value == null && fallback != null) {
      return fallback;
    }
    if (value is num) {
      return value.toDouble();
    }
    throw FormatException('Expected "$key" to be a number.');
  }

  Map<String, dynamic> object(String key) {
    final Object? value = this[key];
    if (value is Map<Object?, Object?>) {
      return Map<String, dynamic>.from(value);
    }
    throw FormatException('Expected "$key" to be an object.');
  }

  Map<String, dynamic>? optionalObject(String key) {
    final Object? value = this[key];
    if (value == null) {
      return null;
    }
    if (value is Map<Object?, Object?>) {
      return Map<String, dynamic>.from(value);
    }
    throw FormatException('Expected "$key" to be an object or null.');
  }

  List<Map<String, dynamic>> objectList(String key, {bool required = true}) {
    final Object? value = this[key];
    if (value == null && !required) {
      return <Map<String, dynamic>>[];
    }
    if (value is! List<Object?>) {
      throw FormatException('Expected "$key" to be a list.');
    }
    return value.map((Object? item) {
      if (item is Map<Object?, Object?>) {
        return Map<String, dynamic>.from(item);
      }
      throw FormatException('Expected every "$key" item to be an object.');
    }).toList();
  }

  List<String> stringList(String key, {bool required = true}) {
    final Object? value = this[key];
    if (value == null && !required) {
      return <String>[];
    }
    if (value is! List<Object?> || value.any((Object? item) => item is! String)) {
      throw FormatException('Expected "$key" to be a string list.');
    }
    return value.cast<String>();
  }
}
