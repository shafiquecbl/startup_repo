# Code Architecture Documentation

## Introduction

This document provides a detailed overview of the code architecture for the `startup_repo` Flutter project. It explains the purpose of each folder and file, the assets included, and the packages used. This documentation aims to help developers understand the project structure and how to work with it effectively.

## Project Structure

The project is organized into several folders, each with a specific purpose:

### `controllers`

Manages state management using the `Get` package. Each controller is responsible for a specific part of the application state and interacts with the corresponding service.

### `data`

Handles all data-related operations, including API calls, data models, repositories, and services.

#### `api`

Manages API calls using the `http` package. Contains classes that handle HTTP requests and responses.

#### `model`

Contains data models used throughout the application.

- **`body`**: Models for sending data to the API.
- **`response`**: Models for receiving data from the API.
- **`other`**: Models used within the app for various purposes.

#### `repository`

Handles the final step of getting or sending data to the API or local storage. Acts as an intermediary between the data source and the rest of the application. Each repository can have multiple required parameters, such as API client interface and shared preferences.

#### `service`

Contains the logical part of the controllers. Each service has a required parameter, which is their repository class interface. Services implement the business logic and interact with repositories to fetch or save data.

### `helper`

Contains helper functions and classes that provide utility methods and functionalities used across the application.

### `theme`

Contains dark and light themes for the application. Defines the visual styling and appearance of the app.

### `utils`

Contains utility files that provide constants, colors, images, styles, and other reusable components.

- **`app_constants.dart`**: Contains app-wide constants.
- **`colors.dart`**: Manages app colors.
- **`images.dart`**: Manages image assets.
- **`style.dart`**: Contains common styles.

### `view`

Manages the UI components of the application. Contains screens and reusable widgets.

- **`base`**: Contains common reusable widgets used in multiple screens.
- **`screen`**: Contains all screens. Each screen has a separate folder, which can further contain a `widgets` folder for reusable widgets specific to that screen.

## Detailed Explanation

### Controllers

The `controllers` folder contains classes that manage the state of the application. These classes use the `Get` package for state management. Each controller has a required parameter, which is their service class interface.

#### Example: `ThemeController`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/service/theme_service_interface.dart';

class ThemeController extends GetxController implements GetxService {
  final ThemeServiceInterface themeService;

  ThemeController({required this.themeService}) {
    _loadCurrentTheme();
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void _loadCurrentTheme() async {
    _themeMode = themeService.loadCurrentTheme();
    update();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    themeService.saveThemeMode(themeMode);
    update();
  }

  static ThemeController get find => Get.find();
}
```

### Services

The `service` folder contains the logical part of the controllers. Each service has a required parameter, which is their repository class interface.

#### Example: `ThemeService`

```dart
import 'package:flutter/material.dart';
import 'package:startup_repo/data/repository/theme_repo_interface.dart';
import 'theme_service_interface.dart';

class ThemeService implements ThemeServiceInterface {
  final ThemeRepoInterface themeRepo;
  ThemeService({required this.themeRepo});

  @override
  ThemeMode loadCurrentTheme() {
    String data = themeRepo.loadCurrentTheme();
    if (data == 'system') {
      return ThemeMode.system;
    } else if (data == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    String mode = 'system';
    switch (themeMode) {
      case ThemeMode.light:
        mode = 'light';
        break;
      case ThemeMode.dark:
        mode = 'dark';
        break;
      default:
        mode = 'system';
    }
    return await themeRepo.saveThemeMode(mode);
  }
}
```

### Service Interfaces

Service interfaces define the contract for the services. They ensure that the services implement the required methods.

#### Example: `ThemeServiceInterface`

```dart
import 'package:flutter/material.dart';

abstract class ThemeServiceInterface {
  ThemeMode loadCurrentTheme();
  Future<bool> saveThemeMode(ThemeMode themeMode);
}
```

### Repositories

The `repository` folder handles the final step of getting or sending data to the API or local storage. Each repository can have multiple required parameters, such as API client interface and shared preferences.

#### Example: `ThemeRepo`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'theme_repo_interface.dart';

class ThemeRepo implements ThemeRepoInterface {
  final SharedPreferences prefs;
  ThemeRepo({required this.prefs});

  @override
  String loadCurrentTheme() {
    return prefs.getString(AppConstants.theme) ?? 'system';
  }

  @override
  Future<bool> saveThemeMode(String themeMode) async {
    return await prefs.setString(AppConstants.theme, themeMode);
  }
}

```

### Repository Interfaces

Repository interfaces define the contract for the repositories. They ensure that the repositories implement the required methods.

#### Example: `ThemeRepoInterface`

```dart
abstract class ThemeRepoInterface {
  String loadCurrentTheme();
  Future<bool> saveThemeMode(String themeMode);
}
```

### API Client

The `api` folder contains classes that manage API calls. These classes use the `http` package to make HTTP requests. The API client can have multiple required parameters, such as shared preferences and base URL.

#### Example: `ApiClient`

```dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import '../../view/base/common/snackbar.dart';
import '../model/response/error.dart';
import 'api_client_interface.dart';

class ApiClient extends GetxService implements ApiClientInterface {
  final SharedPreferences sharedPreferences;
  final String baseUrl;
  ApiClient({required this.sharedPreferences, required this.baseUrl});

  final int timeoutInSeconds = 120;
  http.Client? _client; // Track the client for cancellation

  final Map<String, String> _mainHeaders = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
  };

  @override
  Future<void> cancelRequest() async {
    if (_client != null) {
      _client!.close(); // Cancel the ongoing request
      _client = null; // Reset the client
      debugPrint('====> API request canceled');
    }
  }

  @override
  Future<http.Response?> get(String uri, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!
          .get(url, headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<http.Response?> post(
    String uri,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  }) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');
      debugPrint('====> Body: $body');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!.post(
        url,
        body: jsonEncode(body),
        headers: {
          ..._mainHeaders,
          if (headers != null) ...headers,
        },
      ).timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<http.Response?> put(
    String uri,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  }) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');
      debugPrint('====> Body: $body');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!.put(
        url,
        body: jsonEncode(body),
        headers: {
          ..._mainHeaders,
          if (headers != null) ...headers,
        },
      ).timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<http.Response?> delete(String uri, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(AppConstants.baseUrl + uri);
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!
          .delete(url, headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response);
    } catch (e) {
      _client = null; // Reset the client after completion
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<Uint8List?> downloadImage(String uri) async {
    try {
      // print the api call
      debugPrint('====> API Call: $uri, ====> Header: $_mainHeaders');

      http.Response response = await http
          .get(
            Uri.parse(uri),
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode != 200) {
        return _handleError(jsonDecode(response.body));
      } else {
        hideLoading();
        return Uint8List.fromList(response.bodyBytes);
      }
    } catch (e) {
      hideLoading();
      _socketException(e);
      return null;
    }
  }

  Future<http.Response?> _handleResponse(http.Response response) async {
    if (response.statusCode != 200) {
      return _handleError(jsonDecode(response.body));
    } else {
      hideLoading();
      return response;
    }
  }

  _handleError(Map<String, dynamic> body) {
    if (body.containsKey('message')) {
      showToast(body['message']);
      return null;
    }
    ErrorResponse response = ErrorResponse.fromJson(body);
    hideLoading();
    showToast(response.errors.first.message);
    return null;
  }

  _socketException(Object e) {
    if (e is SocketException) {
      showToast('Please check your internet connection');
    } else {
      if (e is http.ClientException) {
        if (e.message != 'Connection closed before full header was received') {
          showToast('Something went wrong');
        }
      } else {
        showToast('Something went wrong');
      }
    }
  }
}
```

### API Client Interfaces

API client interfaces define the contract for the API clients. They ensure that the API clients implement the required methods.

#### Example: `ApiClientInterface`

```dart
import 'dart:typed_data';
import 'package:http/http.dart';

abstract class ApiClientInterface {
  Future<void> cancelRequest();

  Future<Response?> get(
    String uri, {
    Map<String, String>? headers,
  });

  Future<Response?> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  });

  Future<Response?> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  });

  Future<Response?> delete(
    String url, {
    Map<String, String>? headers,
  });

  Future<Uint8List?> downloadImage(String uri);
}
```

### Dependency Injection

Dependency injection is used to manage the dependencies between different classes. The `Get` package is used for dependency injection.

#### Example: `get_di.dart`

```dart
// Core
final sharedPreferences = await SharedPreferences.getInstance();
Get.lazyPut(() => sharedPreferences);
ApiClientInterface apiClient = ApiClient(sharedPreferences: Get.find(), baseUrl: AppConstants.baseUrl);
Get.lazyPut(() => apiClient);

// Repository
LocalizationRepoInterface localizationRepo = LocalizationRepo(prefs: Get.find());
Get.lazyPut(() => localizationRepo);
ThemeRepoInterface themeRepo = ThemeRepo(prefs: Get.find());
Get.lazyPut(() => themeRepo);
SplashRepoInterface splashRepo = SplashRepo(apiClient: Get.find(), prefs: Get.find());
Get.lazyPut(() => splashRepo);

// Service
LocalizationServiceInterface localizationService = LocalizationService(localizationRepo: Get.find());
Get.lazyPut(() => localizationService);
ThemeServiceInterface themeService = ThemeService(themeRepo: Get.find());
Get.lazyPut(() => themeService);
SplashServiceInterface splashService = SplashService(splashRepo: Get.find());
Get.lazyPut(() => splashService);

// Controller
Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
Get.lazyPut(() => ThemeController(themeService: Get.find()));
Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
```

## Conclusion

By understanding the project structure, the purpose of each folder and file, and the assets and packages included in the project, you will be able to work more effectively with the `startup_repo` Flutter project. This documentation aims to provide you with a comprehensive understanding of the project to help you contribute and maintain it efficiently.
