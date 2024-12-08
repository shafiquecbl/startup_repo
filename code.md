# Code Architecture Documentation

## Introduction

This document provides a detailed overview of the code architecture for the `startup_repo` Flutter project. It explains the purpose of each folder and file, the assets included, and the packages used. This documentation aims to help developers understand the project structure and how to work with it effectively.

## Project Structure

The project is organized into several folders, each with a specific purpose:

- `controllers`: Manages state management.
- `data`: Handles data-related operations.
  - `api`: Manages API calls.
  - `model`: Contains data models.
    - `body`: Models for sending data to the API.
    - `response`: Models for receiving data from the API.
    - `other`: Models used within the app.
  - `repository`: Handles the final step of getting or sending data to the API or local storage.
  - `service`: Contains the logical part of the controllers.
- `helper`: Contains helper functions and classes.
- `theme`: Contains dark and light themes.
- `utils`: Contains utility files.
- `view`: Manages the UI.

## Detailed Explanation

### Controllers

The `controllers` folder contains classes that manage the state of the application. These classes use the `Get` package for state management.

#### Example: `localization_controller.dart`

```dart
import 'package:get/get.dart';
import 'package:startup_repo/data/service/localization_service_interface.dart';

class LocalizationController extends GetxController {
  final LocalizationServiceInterface localizationService;

  LocalizationController({required this.localizationService});

  // Add your controller logic here
}
```

### Data

The `data` folder handles all data-related operations.

#### API

The `api` folder contains classes that manage API calls. These classes use the `http` package to make HTTP requests.

#### Example: `api_client.dart`

```dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_repo/utils/app_constants.dart';

class ApiClient {
  final SharedPreferences sharedPreferences;
  final String baseUrl;

  ApiClient({required this.sharedPreferences, required this.baseUrl});

  Future<http.Response> get(String url) async {
    final response = await http.get(Uri.parse(baseUrl + url));
    return response;
  }

  Future<http.Response> post(String url, {required Map<String, dynamic> body}) async {
    final response = await http.post(Uri.parse(baseUrl + url), body: body);
    return response;
  }
}
```

#### Model

The `model` folder contains data models.

##### Body

Contains models for sending data to the API.

##### Example: `login_body.dart`

```dart
class LoginBody {
  final String email;
  final String password;

  LoginBody({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
```

##### Response

Contains models for receiving data from the API.

##### Example: `login_response.dart`

```dart
class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
    );
  }
}
```

##### Other

Contains models used within the app.

##### Example: `user.dart`

```dart
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
```

#### Repository

The `repository` folder handles the final step of getting or sending data to the API or local storage. It acts as an intermediary between the data source and the rest of the application.

##### Example: `localization_repo.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_repo/data/repository/localization_repo_interface.dart';

class LocalizationRepo implements LocalizationRepoInterface {
  final SharedPreferences prefs;

  LocalizationRepo({required this.prefs});

  @override
  Locale loadCurrentLanguage() {
    // Load the current language from shared preferences
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    // Save the language to shared preferences
  }

  @override
  List<Locale> get availableLanguages {
    // Return the list of available languages
  }
}
```

#### Service

The `service` folder contains the logical part of the controllers. Controllers only have variables, while the complete logical part is in the service.

##### Example: `localization_service.dart`

```dart
import 'package:flutter/material.dart';
import 'package:startup_repo/data/repository/localization_repo_interface.dart';
import 'localization_service_interface.dart';

class LocalizationService implements LocalizationServiceInterface {
  final LocalizationRepoInterface localizationRepo;

  LocalizationService({required this.localizationRepo});

  @override
  Locale loadCurrentLanguage() {
    return localizationRepo.loadCurrentLanguage();
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    await localizationRepo.saveLanguage(locale);
  }

  @override
  List<Locale> get availableLanguages {
    return localizationRepo.availableLanguages;
  }
}
```

### Helper

The `helper` folder contains helper functions and classes.

#### Example: `dependency_injection.dart`

```dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_repo/controller/localization_controller.dart';
import 'package:startup_repo/controller/theme_controller.dart';
import 'package:startup_repo/data/repository/localization_repo.dart';
import 'package:startup_repo/data/repository/theme_repo.dart';
import 'package:startup_repo/data/service/localization_service.dart';
import 'package:startup_repo/data/service/theme_service.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repositories
  Get.lazyPut(() => LocalizationRepo(prefs: Get.find()));
  Get.lazyPut(() => ThemeRepo(prefs: Get.find()));

  // Services
  Get.lazyPut(() => LocalizationService(localizationRepo: Get.find()));
  Get.lazyPut(() => ThemeService(themeRepo: Get.find()));

  // Controllers
  Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  Get.lazyPut(() => ThemeController(themeService: Get.find()));
}
```

### Theme

The `theme` folder contains dark and light themes for the application.

#### Example: `dark_theme.dart`

```dart
import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  accentColor: Colors.blueAccent,
  // Add other theme properties here
);
```

#### Example: `light_theme.dart`

```dart
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.blueAccent,
  // Add other theme properties here
);
```

### Utils

The `utils` folder contains utility files.

#### Example: `app_constants.dart`

```dart
class AppConstants {
  static const String BASE_URL = 'https://api.example.com';
  static const String THEME = 'theme';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  // Add other constants here
}
```

#### Example: `colors.dart`

```dart
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6949FF);
const Color secondaryColor = Color(0xFFD27579);

// background color
const Color backgroundColorDark = Colors.black;
const Color backgroundColorLight = Color(0xFFFFFFFF);

// card color
const Color cardColorDark = Color(0xFF222222);
const Color cardColorLight = Color(0xFFF7F8FA);

// text color
const Color textColordark = Color(0XFFDADADA);
const Color textColorLight = Colors.black;

// shadow color
const Color shadowColorDark = Color(0xFF0A1220);
const Color shadowColorLight = Color(0xFFE8E8E8);

// hint color
const Color hintColorDark = Color(0xFFA4A6A4);
const Color hintColorLight = Color(0xFF9F9F9F);

// disabled color
const Color disabledColorDark = Color(0xffa2a7ad);
const Color disabledColorLight = Color(0xffa2a7ad);

// divider Color
const Color dividerColorDark = Color(0xFF424242);
const Color dividerColorLight = Color(0xFFBDBDBD);

// icon color
const Color iconColorDark = Colors.white;
const Color iconColorLight = Colors.black;

// gradient
const LinearGradient primaryGradient = LinearGradient(
  colors: [secondaryColor, primaryColor],
  stops: [0.2, 1.0],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
```

#### Example: `images.dart`

```dart
class Images {
  static const String logo = 'assets/images/logo.png';
  static const String background = 'assets/images/background.png';
  // Add other image paths here
}
```

#### Example: `style.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Padding and BorderRadius
EdgeInsets pagePadding = EdgeInsets.all(16.sp);
double get radius => 16.sp;
BorderRadius get borderRadius => BorderRadius.circular(16.sp);

// Text Styles (using Theme.of(context).textTheme)
TextStyle displayLarge(BuildContext context) => Theme.of(context).textTheme.displayLarge!;
TextStyle displayMedium(BuildContext context) => Theme.of(context).textTheme.displayMedium!;
TextStyle displaySmall(BuildContext context) => Theme.of(context).textTheme.displaySmall!;
TextStyle headlineLarge(BuildContext context) => Theme.of(context).textTheme.headlineLarge!;
TextStyle headlineMedium(BuildContext context) => Theme.of(context).textTheme.headlineMedium!;
TextStyle headlineSmall(BuildContext context) => Theme.of(context).textTheme.headlineSmall!;
TextStyle titleLarge(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
TextStyle titleMedium(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
TextStyle titleSmall(BuildContext context) => Theme.of(context).textTheme.titleSmall!;
TextStyle bodyLarge(BuildContext context) => Theme.of(context).textTheme.bodyLarge!;
TextStyle bodyMedium(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;
TextStyle bodySmall(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
TextStyle labelLarge(BuildContext context) => Theme.of(context).textTheme.labelLarge!;
TextStyle labelMedium(BuildContext context) => Theme.of(context).textTheme.labelMedium!;
TextStyle labelSmall(BuildContext context) => Theme.of(context).textTheme.labelSmall!;
```

### View

The `view` folder manages the UI.

#### Base

Contains common reusable widgets used in multiple screens.

##### Example: `loading.dart`

```dart
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
```

#### Screen

Contains all screens. Each screen has a separate folder, which can further contain a `widgets` folder for reusable widgets specific to that screen.

##### Example: Home Screen

###### `home.dart`

```dart
import 'package:flutter/material.dart';
import 'package:startup_repo/utils/style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // demonstrate all the text theme,
            Text(
              'Display Large (${displayLarge(context).fontSize?.ceilToDouble()})',
              style: displayLarge(context),
            ),
            Text(
              'Display Medium (${displayMedium(context).fontSize?.ceilToDouble()})',
              style: displayMedium(context),
            ),
            Text(
              'Display Small (${displaySmall(context).fontSize?.ceilToDouble()})',
              style: displaySmall(context),
            ),
            Text(
              'Headline Large (${headlineLarge(context).fontSize?.ceilToDouble()})',
              style: headlineLarge(context),
            ),
            Text(
              'Headline Medium (${headlineMedium(context).fontSize?.ceilToDouble()})',
              style: headlineMedium(context),
            ),
            Text(
              'Headline Small (${headlineSmall(context).fontSize?.ceilToDouble()})',
              style: headlineSmall(context),
            ),
            Text(
              'Title Large (${titleLarge(context).fontSize?.ceilToDouble()})',
              style: titleLarge(context),
            ),
            Text(
              'Title Medium (${titleMedium(context).fontSize?.ceilToDouble()})',
              style: titleMedium(context),
            ),
            Text(
              'Title Small (${titleSmall(context).fontSize?.ceilToDouble()})',
              style: titleSmall(context),
            ),
            Text(
              'Body Large (${bodyLarge(context).fontSize?.ceilToDouble()})',
              style: bodyLarge(context),
            ),
            Text(
              'Body Medium (${bodyMedium(context).fontSize?.ceilToDouble()})',
              style: bodyMedium(context),
            ),
            Text(
              'Body Small (${bodySmall(context).fontSize?.ceilToDouble()})',
              style: bodySmall(context),
            ),
            Text(
              'Label Large (${labelLarge(context).fontSize?.ceilToDouble()})',
              style: labelLarge(context),
            ),
            Text(
              'Label Medium (${labelMedium(context).fontSize?.ceilToDouble()})',
              style: labelMedium(context),
            ),
            Text(
              'Label Small (${labelSmall(context).fontSize?.ceilToDouble()})',
              style: labelSmall(context),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Assets

The project includes various assets such as images and icons. These assets are used to enhance the visual appeal of the application.

## Packages

The project includes several packages, each with a specific purpose:

- `get`: Used for state management and dependency injection.
- `intl`: Provides internationalization and localization support.
- `http`: Used for making HTTP requests.
- `iconsax`: Provides a collection of icons.
- `shimmer`: Used for creating shimmer effects.
- `google_fonts`: Provides access to Google Fonts.
- `url_launcher`: Used for launching URLs.
- `flutter_dotenv`: Used for loading environment variables from a `.env` file.
- `connectivity_plus`: Provides connectivity status.
- `flutter_screenutil`: Provides screen size and font size adaptation.
- `shared_preferences`: Used for storing key-value pairs locally.
- `cached_network_image`: Used for caching network images.
- `flutter_smart_dialog`: Provides smart dialog support.

## Conclusion

By understanding the project structure, the purpose of each folder and file, and the assets and packages included in the project, you will be able to work more effectively with the `startup_repo` Flutter project. This documentation aims to provide you with a comprehensive understanding of the project to help you contribute and maintain it efficiently.
