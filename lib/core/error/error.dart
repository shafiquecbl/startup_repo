class ErrorResponse {
  final List<Error> errors;

  ErrorResponse({required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      errors: json['error'] != null
          ? [Error.fromJson(json['error'])]
          : List<Error>.from(json['errors'].map((x) => Error.fromJson(x))),
    );
  }
}

class Error {
  final String message;
  Error({required this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(message: json['message']);
  }
}
