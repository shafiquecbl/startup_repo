# API Client

The API foundation keeps transport and feature parsing separate:

```text
Controller → Service → Repository → ApiRequest → ApiClient → ApiResult<Object?>
```

## Responsibilities

```text
core/api/
├── client/   # Dio transport and headers
├── model/    # Request, result, and failure values
└── support/  # Backend error parsing, mapping, and localization
```

- `ApiClient` executes a request and returns the raw decoded Dio body.
- Repository calls API/storage/database only. It does not import feature models or parse successful data.
- Service builds request data, parses successful raw data, and applies feature logic.
- Controller owns loading/error/empty/content state. It never handles `ApiResult` or raw JSON.

```dart
Future<ApiResult<Object?>> getData() =>
    apiClient.execute(const ApiRequest(method: ApiMethod.get, path: Endpoints.featureData));

Future<FeatureModel?> loadData() async {
  final ApiResult<Object?> result = await featureRepo.getData();
  if (result case Success<Object?>(data: final Object? data)) {
    return FeatureModel.fromJson(readJsonMap(data));
  }
  return null;
}
```

For list queries, use `List<Model>?`: `null` means failure and an empty list means a successful empty result.

## Error feedback

- `GET` and `HEAD` failures are silent by default.
- `POST`, `PUT`, `PATCH`, and `DELETE` failures show one deduplicated error toast by default.
- Cancelled requests never show feedback.
- `ApiErrorFeedback.toast` opts a read into feedback.
- `ApiErrorFeedback.silent` suppresses a background mutation or inline form-validation error.
- Success feedback belongs to the controller because only the feature knows whether the result is already visible.

```dart
ApiRequest(
  method: ApiMethod.get,
  path: Endpoints.search,
  errorFeedback: ApiErrorFeedback.toast,
);

ApiRequest(
  method: ApiMethod.post,
  path: Endpoints.backgroundSync,
  data: body,
  errorFeedback: ApiErrorFeedback.silent,
);
```

## Failures

`Failure<Object?>` contains an `ApiFailure` with:

- transport/status kind;
- optional backend message and code;
- optional validation field errors;
- optional HTTP status and trace ID.

`ApiErrorParser` understands common backend error shapes. `ApiFailureMapper` owns transport/status mapping.
`ApiErrorLocalizer` chooses the backend message or localized fallback.

## Headers and cancellation

Application-wide headers use `updateHeader`:

```dart
apiClient.updateHeader('Accept-Language', languageCode);
apiClient.updateHeader('Authorization', 'Bearer $token');
apiClient.updateHeader('Authorization', null);
```

Request-specific headers and Dio `CancelToken` belong to `ApiRequest`.

Authentication, credential persistence, retry policy, and request logging are not part of the starter API client.
