# Code Documentation - Startup Repo

**Version:** 1.0.0  
**Flutter Version:** 3.29.2  
**State Management:** GetX  
**Architecture:** Clean Architecture + Feature-First

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Diagram](#architecture-diagram)
3. [Project Structure](#project-structure)
4. [Core Layer Documentation](#core-layer-documentation)
5. [Features Layer Documentation](#features-layer-documentation)
6. [Design System](#design-system)
7. [State Management & Dependency Injection](#state-management--dependency-injection)
8. [API Client Architecture](#api-client-architecture)
9. [Theme System](#theme-system)
10. [Localization System](#localization-system)
11. [Configuration & Environment](#configuration--environment)
12. [Dependencies](#dependencies)
13. [Widget Catalog](#widget-catalog)
14. [How to Add a New Feature](#how-to-add-a-new-feature)
15. [How to Add a New API Endpoint](#how-to-add-a-new-api-endpoint)

---

## Project Overview

**startup_repo** is a production-ready Flutter boilerplate/starter template designed to accelerate development of new Flutter applications. It provides a solid foundation with pre-configured architecture, state management, theming, localization, and reusable components.

### Purpose
- **Boilerplate for Flutter projects** - Save weeks of initial setup time
- **Best practices implementation** - Clean Architecture, SOLID principles
- **Scalable structure** - Easily add new features without refactoring
- **Production-ready components** - Reusable widgets, theme system, API client
- **Multi-platform support** - Android & iOS with centralized configuration

### Key Features
✅ Clean Architecture with feature-first approach  
✅ GetX state management & dependency injection  
✅ Complete design system (colors, typography, spacing, radius)  
✅ Theme switching (Light/Dark/System)  
✅ Multi-language support (English, Arabic) with easy expansion  
✅ HTTP API client with interface/implementation pattern  
✅ Connectivity checking with user feedback  
✅ Environment-based configuration (.env for Android, .xcconfig for iOS)  
✅ Reusable widget library  
✅ Responsive design with flutter_screenutil  

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Main App                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  MyApp (ScreenUtilInit, GetMaterialApp)             │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────▼────────┐   ┌────────▼────────┐   ┌───────▼────────┐
│   Core Layer   │   │ Features Layer  │   │  DI (get_di)   │
└────────────────┘   └─────────────────┘   └────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                        CORE LAYER                             │
├──────────────────────────────────────────────────────────────┤
│ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│ │  Design  │ │   API    │ │  Helper  │ │  Theme   │        │
│ │  System  │ │  Client  │ │   (DI)   │ │          │        │
│ └──────────┘ └──────────┘ └──────────┘ └──────────┘        │
│ ┌──────────┐ ┌──────────┐                                   │
│ │  Utils   │ │  Widgets │                                   │
│ └──────────┘ └──────────┘                                   │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                      FEATURES LAYER                           │
│  Each feature follows Clean Architecture:                    │
│                                                               │
│  Feature (e.g., Splash, Language, Theme, Home)               │
│  ├── data/                                                    │
│  │   ├── model/          (Data models/DTOs)                  │
│  │   └── repository/     (Data access - interface & impl)    │
│  ├── domain/                                                  │
│  │   ├── binding/        (DI binding for this feature)       │
│  │   └── service/        (Business logic - interface & impl) │
│  └── presentation/                                            │
│      ├── controller/     (State management with GetX)        │
│      └── view/           (UI screens and widgets)            │
└──────────────────────────────────────────────────────────────┘

DATA FLOW:
View → Controller → Service → Repository → API/Local Storage
                      ↓
               Business Logic
                      ↓
View ← Controller ← Service ← Repository ← Response
```

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── imports.dart                 # Centralized exports for common imports
│
├── core/                        # Shared across entire app
│   ├── api/                     # HTTP client
│   │   ├── api_client.dart           # Interface (abstract class)
│   │   ├── api_client_impl.dart      # Implementation with http package
│   │   └── error.dart                # Error models
│   │
│   ├── design/                  # Design system utilities
│   │   ├── design_system.dart        # Exports all design utilities
│   │   ├── colors.dart               # Color palette
│   │   ├── app_padding.dart          # Standardized padding
│   │   ├── app_radius.dart           # Standardized border radius
│   │   └── app_text.dart             # Text style extensions
│   │
│   ├── helper/                  # Helper utilities
│   │   ├── get_di.dart               # Central DI initialization
│   │   ├── connectivity.dart         # Network connectivity check
│   │   ├── navigation.dart           # Navigation helpers
│   │   └── notification_helper.dart  # (Commented) Firebase notifications
│   │
│   ├── theme/                   # Theme definitions
│   │   ├── light_theme.dart          # Light theme
│   │   ├── dark_theme.dart           # Dark theme
│   │   ├── design_helper.dart        # Responsive design helper
│   │   └── src/                      # Theme components
│   │       ├── text_theme.dart
│   │       ├── elevated_button_theme.dart
│   │       ├── textbuton_theme.dart
│   │       ├── outline_button_theme.dart
│   │       ├── appbar_theme.dart
│   │       ├── input_decoration_theme.dart
│   │       ├── dropdown_theme.dart
│   │       ├── dialog_theme.dart
│   │       ├── bottom_sheet_theme.dart
│   │       ├── icon_theme.dart
│   │       └── divider_theme.dart
│   │
│   ├── utils/                   # Constants and utilities
│   │   ├── app_constants.dart        # App name, base URL, endpoints
│   │   ├── images.dart               # Image asset paths
│   │   ├── messages.dart             # Localization messages class
│   │   ├── shared_keys.dart          # SharedPreferences keys
│   │   └── scroll_behavior.dart      # Custom scroll behavior
│   │
│   └── widgets/                 # Reusable widgets
│       ├── confirmation_dialog.dart  # Confirmation dialog
│       ├── confirmation_sheet.dart   # Bottom sheet confirmation
│       ├── loading.dart              # Loading indicators
│       ├── network_image.dart        # Cached network image
│       ├── primary_button.dart       # Primary & outline buttons
│       ├── shimmer.dart              # Shimmer effect
│       ├── snackbar.dart             # Toast/loading helpers
│       └── textfield.dart            # Custom text field & dropdown
│
└── features/                    # Feature modules
    ├── home/                    # Home feature (demo screen)
    │   └── presentation/
    │       └── view/
    │           └── home.dart
    │
    ├── language/                # Localization feature
    │   ├── data/
    │   │   ├── model/
    │   │   │   └── language.dart
    │   │   └── repository/
    │   │       ├── localization_repo_interface.dart
    │   │       └── localization_repo.dart
    │   ├── domain/
    │   │   ├── binding/
    │   │   │   └── language_binding.dart
    │   │   └── service/
    │   │       ├── localization_service.dart
    │   │       └── localization_service_impl.dart
    │   └── presentation/
    │       ├── controller/
    │       │   └── localization_controller.dart
    │       └── view/
    │           └── language.dart
    │
    ├── splash/                  # Splash/config feature
    │   ├── data/
    │   │   ├── model/
    │   │   │   └── config_model.dart
    │   │   └── repository/
    │   │       ├── splash_repo.dart
    │   │       └── splash_repo_impl.dart
    │   ├── domain/
    │   │   ├── binding/
    │   │   │   └── splash_binding.dart
    │   │   └── service/
    │   │       ├── splash_service.dart
    │   │       └── splash_service_impl.dart
    │   └── presentation/
    │       └── controller/
    │           └── splash_controller.dart
    │
    └── theme/                   # Theme switching feature
        ├── data/
        │   └── repository/
        │       ├── theme_repo.dart
        │       └── theme_repo_impl.dart
        ├── domain/
        │   ├── binding/
        │   │   └── theme_binding.dart
        │   └── service/
        │       ├── theme_service.dart
        │       └── theme_service_impl.dart
        └── presentation/
            └── controller/
                └── theme_controller.dart
```

---

## Core Layer Documentation

### 1. API Client (`core/api/`)

The API client uses an **interface/implementation pattern** for flexibility and testability.

#### **api_client.dart** (Interface)
```dart
abstract class ApiClient {
  String? token;
  void updateHeader(String token, String languageCode);
  Future<void> cancelRequest();
  Future<Response?> get(String uri, {Map<String, String>? headers, Map<String, String>? queryParams});
  Future<Response?> post(String url, Map<String, dynamic> body, {Map<String, String>? headers});
  Future<Response?> put(String url, Map<String, dynamic> body, {Map<String, String>? headers});
  Future<Response?> delete(String url, {Map<String, String>? headers});
  Future<Uint8List?> downloadImage(String uri);
}
```

**Purpose:** Defines the contract for API operations.

#### **api_client_impl.dart** (Implementation)
```dart
class ApiClientImpl extends GetxService implements ApiClient {
  final SharedPreferences prefs;
  final String baseUrl;
  final int timeoutInSeconds = 120;
  
  ApiClientImpl({required this.prefs, required this.baseUrl}) {
    token = prefs.getString(SharedKeys.token);
    updateHeader(token ?? '', prefs.getString(SharedKeys.languageCode));
  }
  // ... implementation
}
```

**Key Features:**
- **Automatic headers:** Sets Content-Type, Authorization, localization headers
- **Token management:** Reads from SharedPreferences, updates headers
- **Connectivity check:** Uses `ConnectivityService` before making requests
- **Error handling:** Parses error responses, shows toasts
- **Request cancellation:** Can cancel in-flight requests
- **Auto logout:** Detects "Unauthenticated" responses

**Methods:**
- `get()` - GET requests with optional query params
- `post()` - POST with JSON body
- `put()` - PUT with JSON body
- `delete()` - DELETE requests
- `downloadImage()` - Downloads image as bytes

#### **error.dart**
```dart
class ErrorResponse {
  final List<Error> errors;
  factory ErrorResponse.fromJson(Map<String, dynamic> json) { ... }
}

class Error {
  final String message;
  factory Error.fromJson(Map<String, dynamic> json) { ... }
}
```

**Purpose:** Standardized error parsing from API responses.

---

### 2. Design System (`core/design/`)

A comprehensive design system for consistent UI across the app.

#### **colors.dart**
Defines the complete color palette:
```dart
// Primary colors
const Color primaryColor = Color(0xFF6949FF);
const Color secondaryColor = Color(0xFFD27579);

// Background colors (theme-specific)
const Color backgroundColorLight = Color(0xFFFFFFFF);
const Color backgroundColorDark = Color(0xFF1E1E1E);

// Card colors
const Color cardColorLight = Color(0xFFF5F5F5);
const Color cardColorDark = Color(0xFF2A2A2A);

// Shadow colors
const Color shadowColorLight = Color(0xFFE8E8E8);
const Color shadowColorDark = Color(0xFF3A3A3A);

// Divider colors
const Color dividerColorLight = Color(0xFFD0D5DD);
const Color dividerColorDark = Color(0xFF3F3F3F);

// Hint/placeholder colors
const Color hintColorLight = Color(0xff606060);
const Color hintColorDark = Color(0xFF909090);

// Text colors
const Color textColorLight = Colors.black;
const Color textColorDark = Colors.white;

// Icon colors
const Color iconColorLight = Color(0xff606060);
const Color iconColorDark = Color(0xFF909090);

// Gradient
LinearGradient get primaryGradient => LinearGradient(
  colors: [secondaryColor, primaryColor],
  stops: [0.2, 1.0],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
```

#### **app_padding.dart**
Standardized padding system:
```dart
class AppPadding {
  // All sides padding
  static EdgeInsets get padding4 => EdgeInsets.all(4.sp);
  static EdgeInsets get padding8 => EdgeInsets.all(8.sp);
  static EdgeInsets get padding12 => EdgeInsets.all(12.sp);
  static EdgeInsets get padding16 => EdgeInsets.all(16.sp);
  static EdgeInsets get padding20 => EdgeInsets.all(20.sp);
  static EdgeInsets get padding24 => EdgeInsets.all(24.sp);
  static EdgeInsets get padding32 => EdgeInsets.all(32.sp);

  // Symmetric padding
  static EdgeInsets vertical(double padding) => EdgeInsets.symmetric(vertical: padding.sp);
  static EdgeInsets horizontal(double padding) => EdgeInsets.symmetric(horizontal: padding.sp);

  // Common presets
  static EdgeInsets get paddingScreen => padding16;
  static EdgeInsets get paddingCard => EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp);
}
```

**Usage:**
```dart
Padding(padding: AppPadding.padding16, child: ...)
Padding(padding: AppPadding.horizontal(20), child: ...)
```

#### **app_radius.dart**
Standardized border radius:
```dart
class AppRadius {
  // Raw values
  static double get radius4 => 4.r;
  static double get radius8 => 8.r;
  static double get radius12 => 12.r;
  static double get radius16 => 16.r;
  static double get radius24 => 24.r;
  static double get radius100 => 100.r;

  // BorderRadius objects
  static BorderRadius get circular4 => BorderRadius.circular(radius4);
  static BorderRadius get circular8 => BorderRadius.circular(radius8);
  static BorderRadius get circular12 => BorderRadius.circular(radius12);
  static BorderRadius get circular16 => BorderRadius.circular(radius16);
  static BorderRadius get circular24 => BorderRadius.circular(radius24);
  static BorderRadius get circular100 => BorderRadius.circular(radius100);

  // Shapes (for buttons, etc.)
  static get circular4Shape => RoundedRectangleBorder(borderRadius: circular4);
  static get circular16Shape => RoundedRectangleBorder(borderRadius: circular16);
  // ... more shapes

  // Specific corners
  static BorderRadius topLeft(double radius) => ...;
  static BorderRadius top(double radius) => ...;
  static BorderRadius bottom(double radius) => ...;
}
```

**Usage:**
```dart
Container(
  decoration: BoxDecoration(borderRadius: AppRadius.circular16),
)
```

#### **app_text.dart**
Text style extensions on BuildContext:
```dart
extension AppText on BuildContext {
  TextStyle get font34 => Theme.of(this).textTheme.displayLarge!;
  TextStyle get font32 => Theme.of(this).textTheme.displayMedium!;
  // ... down to font6
}
```

**Usage:**
```dart
Text('Hello', style: context.font16.copyWith(fontWeight: FontWeight.bold))
```

**Font Sizes:**
- `font34` - Display Large (34sp, w700)
- `font32` - Display Medium (32sp, w600)
- `font30` - Display Small (30sp, w600)
- `font28` - Headline Large (28sp, w600)
- `font26` - Headline Medium (26sp, w600)
- `font24` - Headline Small (24sp, w500)
- `font22` - Title Large (22sp, w500)
- `font20` - Title Medium (20sp, w500)
- `font18` - Title Small (18sp, w500)
- `font16` - Body Large (16sp, w400)
- `font14` - Body Medium (14sp, w400)
- `font12` - Body Small (12sp, w400)
- `font10` - Label Large (10sp, w500)
- `font8` - Label Medium (8sp, w500)
- `font6` - Label Small (6sp, w500)

---

### 3. Helper (`core/helper/`)

#### **get_di.dart** - Central Dependency Injection
```dart
Future<Map<String, Map<String, String>>> init() async {
  // Core dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  ApiClient apiClient = ApiClientImpl(
    prefs: Get.find(),
    baseUrl: AppConstants.baseUrl
  );
  Get.lazyPut(() => apiClient);

  // Feature bindings (centralized registration)
  List<Bindings> bindings = [
    ThemeBinding(),
    LanguageBinding(),
    SplashBinding(),
  ];

  for (Bindings binding in bindings) {
    binding.dependencies();
  }

  // Load language files
  return await _loadLanguages();
}
```

**Purpose:**
- Initialize core dependencies (SharedPreferences, ApiClient)
- Register feature bindings (Theme, Language, Splash)
- Load localization JSON files
- Called once at app startup in `main()`

**Global vs Screen Controllers:**
- **Global:** `LocalizationController`, `ThemeController` - persist throughout app
- **Screen-specific:** Created via feature bindings, auto-disposed when screen closes

#### **connectivity.dart** - Network Check
```dart
class ConnectivityService {
  // Check connectivity and show offline dialog if needed
  static Future<bool> checkAndNotify() async {
    if (!await isConnected()) {
      showOfflineDialog();
      return false;
    }
    return true;
  }

  // Show offline dialog
  static void showOfflineDialog() { ... }

  // Check if connected
  static Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivityResult = 
      await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty && 
           !connectivityResult.contains(ConnectivityResult.none);
  }
}
```

**Usage:** Automatically called by `ApiClientImpl` before each request.

#### **navigation.dart** - Navigation Helpers
```dart
// Navigate to screen
Future<dynamic> launchScreen(Widget child, {
  bool pushAndRemove = false,  // Clear stack
  bool replace = false,        // Replace current
}) async { ... }

// Go back
void pop() => Get.back();
```

**Usage:**
```dart
launchScreen(HomeScreen());
launchScreen(LoginScreen(), pushAndRemove: true);
pop();
```

---

### 4. Theme (`core/theme/`)

#### **light_theme.dart** & **dark_theme.dart**
Complete theme definitions using Material 3:

```dart
ThemeData get light => ThemeData(
  fontFamily: 'Poppins',
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColorLight,
  // ... all theme components
  textTheme: lightTextTheme,
  iconTheme: iconThemeLight,
  appBarTheme: appBarThemeLight,
  elevatedButtonTheme: elevatedButtonThemeData,
  // ... more
);
```

**Theme Components (in `src/`):**
- **text_theme.dart** - All text styles (responsive with ScreenUtil)
- **elevated_button_theme.dart** - Primary button style (50.sp height, circular16, primary color)
- **outline_button_theme.dart** - Outline button style
- **textbuton_theme.dart** - Text button style (transparent, no padding)
- **appbar_theme.dart** - App bar styling (no elevation, title spacing 16.sp)
- **input_decoration_theme.dart** - Text field styling (filled, rounded, border states)
- **dropdown_theme.dart** - Dropdown menu styling
- **dialog_theme.dart** - Dialog styling (circular16, padding32)
- **bottom_sheet_theme.dart** - Bottom sheet styling (top rounded corners)
- **icon_theme.dart** - Icon color and size (22.sp)
- **divider_theme.dart** - Divider styling (0.5 thickness)

#### **design_helper.dart** - Responsive Design
```dart
class DesignHelper {
  static Size getDesignSize(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 600;
    final isLargeTablet = shortestSide > 800;

    if (isLargeTablet) return const Size(1024, 1366);  // Large tablets
    else if (isTablet) return const Size(768, 1024);   // Regular tablets
    else return const Size(411.4, 866.3);              // Phones
  }
}
```

**Purpose:** Provides appropriate design size for ScreenUtilInit based on device type.

---

### 5. Utils (`core/utils/`)

#### **app_constants.dart**
```dart
class AppConstants {
  static String appName = 'Startup Repo';
  static String baseUrl = 'https://api.example.com/';
  static const String configUrl = 'config';
}
```

#### **images.dart**
```dart
class Images {
  static const String logo = 'assets/images/logo.png';
}
```

#### **shared_keys.dart**
SharedPreferences keys:
```dart
class SharedKeys {
  static const String theme = 'theme';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String onBoardingSkip = 'on_boarding_skip';
  static const String token = 'token';
  static const String localizationKey = 'localization';
}
```

#### **messages.dart**
GetX Translations implementation:
```dart
class Messages extends Translations {
  final Map<String, Map<String, String>> languages;
  Messages({required this.languages});

  @override
  Map<String, Map<String, String>> get keys => languages;
}
```

#### **scroll_behavior.dart**
Custom scroll behavior (removes overscroll glow, adds bounce):
```dart
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(...) => child;

  @override
  ScrollPhysics getScrollPhysics(...) => const BouncingScrollPhysics();
}
```

---

### 6. Widgets (`core/widgets/`)

#### **primary_button.dart**
```dart
// Primary button (filled)
PrimaryButton(
  text: 'Submit',
  icon: Icon(Iconsax.tick_circle),
  color: primaryColor,        // optional
  textColor: Colors.white,    // optional
  radius: 16,                 // optional
  onPressed: () { ... },
)

// Outline button
PrimaryOutlineButton(
  text: 'Cancel',
  icon: Icon(Iconsax.close_circle),
  textColor: primaryColor,    // optional
  radius: 16,                 // optional
  onPressed: () { ... },
)
```

#### **textfield.dart**
```dart
// Text field
CustomTextField(
  controller: controller,
  labelText: 'Email',
  hintText: 'Enter your email',
  prefixIcon: Iconsax.sms,
  suffixIcon: Iconsax.eye,
  obscureText: false,
  keyboardType: TextInputType.emailAddress,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
  onChanged: (value) { ... },
)

// Dropdown
CustomDropDown(
  labelText: 'Country',
  hintText: 'Select country',
  items: [
    DropdownMenuItem(value: 'US', child: Text('United States')),
    DropdownMenuItem(value: 'UK', child: Text('United Kingdom')),
  ],
  onChanged: (value) { ... },
)
```

#### **confirmation_dialog.dart** & **confirmation_sheet.dart**
```dart
// Dialog
showConfirmationDialog(
  title: 'Delete Account',
  subtitle: 'This action cannot be undone',
  actionText: 'Delete',
  onAccept: () { ... },
);

// Bottom sheet
showConfirmationSheet(
  title: 'Logout',
  subtitle: 'Are you sure you want to logout?',
  actionText: 'Logout',
  onAccept: () { ... },
);
```

#### **loading.dart**
```dart
// Loading widget
const LoadingWidget()  // For SmartDialog

// Small loading indicator
const Loading(size: 27)
```

#### **snackbar.dart**
```dart
showLoading();           // Show loading overlay
hideLoading();           // Hide loading overlay
showToast('Message');    // Show toast message
```

#### **network_image.dart**
```dart
PrimaryNetworkImage(
  url: 'https://example.com/image.jpg',
  fit: BoxFit.cover,
)
```
**Features:** Cached, shimmer placeholder, error placeholder

#### **shimmer.dart**
```dart
CustomShimmer(
  child: Container(color: Colors.grey[300]),
)
```

---

## Features Layer Documentation

### Architecture Pattern (All Features)

Each feature follows **Clean Architecture** with 3 layers:

```
Feature/
├── data/
│   ├── model/          # Data Transfer Objects (DTOs)
│   └── repository/     # Data access (interface + implementation)
├── domain/
│   ├── binding/        # Dependency injection for this feature
│   └── service/        # Business logic (interface + implementation)
└── presentation/
    ├── controller/     # State management (GetX Controller)
    └── view/           # UI screens and widgets
```

**Data Flow:**
```
View → Controller → Service → Repository → API/SharedPreferences
         ↓             ↓
      UI State    Business Logic
```

---

### 1. Home Feature (`features/home/`)

**Purpose:** Demo screen showcasing all components.

**Files:**
- `presentation/view/home.dart` - Demo screen with buttons, theme switcher, text fields

**Key Components:**
- Font weight showcase (w100-w900)
- Primary & Outline button demos
- Theme mode switcher (System/Light/Dark)
- Text field and dropdown demos
- Confirmation dialog/sheet demos

**No controller** - Uses existing ThemeController.

---

### 2. Language Feature (`features/language/`)

**Purpose:** Multi-language support with language selection screen.

#### Data Layer

**`data/model/language.dart`**
```dart
class LanguageModel {
  String languageName;
  String languageCode;
  String countryCode;
}

List<LanguageModel> appLanguages = [
  LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
  LanguageModel(languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
];
```

**`data/repository/localization_repo_interface.dart`**
```dart
abstract class LocalizationRepo {
  Locale loadCurrentLanguage();
  Future<void> saveLanguage(Locale locale);
  List<Locale> get availableLanguages;
}
```

**`data/repository/localization_repo.dart`**
```dart
class LocalizationRepoImpl implements LocalizationRepo {
  final SharedPreferences prefs;
  
  @override
  Locale loadCurrentLanguage() {
    return Locale(
      prefs.getString(SharedKeys.languageCode) ?? appLanguages.first.languageCode,
      prefs.getString(SharedKeys.countryCode) ?? appLanguages.first.countryCode,
    );
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    Get.updateLocale(locale);
    await prefs.setString(SharedKeys.languageCode, locale.languageCode);
    await prefs.setString(SharedKeys.countryCode, locale.countryCode!);
  }
}
```

#### Domain Layer

**`domain/binding/language_binding.dart`**
```dart
class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocalizationRepoImpl(prefs: Get.find()));
    Get.lazyPut(() => LocalizationServiceImpl(localizationRepo: Get.find()));
    Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  }
}
```

**`domain/service/localization_service.dart`** - Simple pass-through (could add logic here)

#### Presentation Layer

**`presentation/controller/localization_controller.dart`**
```dart
class LocalizationController extends GetxController implements GetxService {
  final LocalizationService localizationService;

  Locale _locale;
  bool _isLtr = true;
  List<LanguageModel> _languages = [];
  int _selectedIndex = 0;

  // Getters
  Locale get locale => _locale;
  bool get isLtr => _isLtr;

  void setLanguage(Locale locale) {
    _locale = locale;
    _isLtr = locale.languageCode != 'ar' && locale.languageCode != 'fa';
    saveLanguage(locale);
    update();
  }

  void searchLanguage(String query) { ... }
}
```

**Key Methods:**
- `loadCurrentLanguage()` - Load saved language on init
- `setLanguage(Locale)` - Change language and update UI
- `searchLanguage(String)` - Filter language list
- `setSelectIndex(int)` - Track selected language

**`presentation/view/language.dart`** - Language selection screen with search

---

### 3. Splash Feature (`features/splash/`)

**Purpose:** Fetch app configuration from API on app start.

#### Data Layer

**`data/model/config_model.dart`**
```dart
class ConfigModel {
  String termsAndConditions;
  String privacyPolicy;
  String userAgreement;
  String cancelAnytime;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    termsAndConditions: json["terms_condition"]["value"],
    privacyPolicy: json["privacy_policy"]["value"],
    userAgreement: json["user_agreement"]["value"],
    cancelAnytime: json["cancel_anytime"]["value"],
  );
}
```

**`data/repository/splash_repo.dart`**
```dart
abstract class SplashRepo {
  Future<Response?> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
```

**`data/repository/splash_repo_impl.dart`**
```dart
class SplashRepoImpl implements SplashRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;

  @override
  Future<Response?> getConfig() async => 
    await apiClient.get(AppConstants.configUrl);

  @override
  bool getFirstTime() => 
    prefs.getBool(SharedKeys.onBoardingSkip) ?? true;
}
```

#### Domain Layer

**`domain/service/splash_service_impl.dart`**
```dart
class SplashServiceImpl implements SplashService {
  final SplashRepo splashRepo;

  @override
  Future<ConfigModel> getConfig() async {
    Response? response = await splashRepo.getConfig();
    if (response != null) {
      return ConfigModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load settings");
    }
  }
}
```

#### Presentation Layer

**`presentation/controller/splash_controller.dart`**
```dart
class SplashController extends GetxController implements GetxService {
  final SplashService settingsService;

  ConfigModel _settingModel;
  ConfigModel get settingModel => _settingModel;

  Future<void> getConfig() async {
    _settingModel = await settingsService.getConfig();
    update();
  }

  bool get isFirstTime => settingsService.getFirstTime();
}
```

**Usage:** Call `SplashController.find.getConfig()` in splash screen.

---

### 4. Theme Feature (`features/theme/`)

**Purpose:** Theme switching (Light/Dark/System).

#### Data Layer

**`data/repository/theme_repo.dart`**
```dart
abstract class ThemeRepo {
  String loadCurrentTheme();
  Future<bool> saveThemeMode(String themeMode);
}
```

**`data/repository/theme_repo_impl.dart`**
```dart
class ThemeRepoImpl implements ThemeRepo {
  final SharedPreferences prefs;

  @override
  String loadCurrentTheme() {
    return prefs.getString(SharedKeys.theme) ?? 'system';
  }

  @override
  Future<bool> saveThemeMode(String themeMode) async {
    return await prefs.setString(SharedKeys.theme, themeMode);
  }
}
```

#### Domain Layer

**`domain/service/theme_service_impl.dart`**
```dart
class ThemeServiceImpl implements ThemeService {
  final ThemeRepo themeRepo;

  @override
  ThemeMode loadCurrentTheme() {
    String data = themeRepo.loadCurrentTheme();
    if (data == 'system') return ThemeMode.system;
    else if (data == 'dark') return ThemeMode.dark;
    else return ThemeMode.light;
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    String mode = 'system';
    switch (themeMode) {
      case ThemeMode.light: mode = 'light'; break;
      case ThemeMode.dark: mode = 'dark'; break;
      default: mode = 'system';
    }
    return await themeRepo.saveThemeMode(mode);
  }
}
```

#### Presentation Layer

**`presentation/controller/theme_controller.dart`**
```dart
class ThemeController extends GetxController implements GetxService {
  final ThemeService themeService;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void _loadCurrentTheme() async {
    _themeMode = themeService.loadCurrentTheme();
    Get.changeThemeMode(_themeMode);
    update();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    themeService.saveThemeMode(themeMode);
    Get.changeThemeMode(_themeMode);
    update();
  }

  static ThemeController get find => Get.find<ThemeController>();
}
```

**Usage:**
```dart
ThemeController.find.setThemeMode(ThemeMode.dark);
```

---

## Design System

### Color Palette

| Purpose | Light | Dark | Hex Light | Hex Dark |
|---------|-------|------|-----------|----------|
| Primary | Purple | Purple | `#6949FF` | `#6949FF` |
| Secondary | Pink | Pink | `#D27579` | `#D27579` |
| Background | White | Dark Gray | `#FFFFFF` | `#1E1E1E` |
| Card | Light Gray | Darker Gray | `#F5F5F5` | `#2A2A2A` |
| Shadow | Light Gray | Dark Gray | `#E8E8E8` | `#3A3A3A` |
| Divider | Gray | Gray | `#D0D5DD` | `#3F3F3F` |
| Disabled | Gray | Gray | `#A0A0A0` | `#B0B0B0` |
| Hint | Dark Gray | Light Gray | `#606060` | `#909090` |
| Text | Black | White | `#000000` | `#FFFFFF` |
| Icon | Dark Gray | Light Gray | `#606060` | `#909090` |

### Spacing System

Uses 4px base unit, scaled with ScreenUtil:
- **4sp** - Micro spacing
- **8sp** - Extra small
- **12sp** - Small
- **16sp** - Medium (default screen padding)
- **20sp** - Large
- **24sp** - Extra large
- **32sp** - Section spacing

### Border Radius

- **4r** - Subtle rounding
- **8r** - Small components
- **12r** - Medium components
- **16r** - Cards, buttons (most common)
- **24r** - Large cards
- **100r** - Circular (avatars, badges)

### Typography

Font: **Poppins** (weights 100-900)

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `font34` | 34sp | 700 | Page titles |
| `font32` | 32sp | 600 | Section headers |
| `font24` | 24sp | 500 | Card titles |
| `font20` | 20sp | 500 | Subtitles |
| `font16` | 16sp | 400 | Body text |
| `font14` | 14sp | 400 | Secondary text |
| `font12` | 12sp | 400 | Captions, buttons |
| `font10` | 10sp | 500 | Labels |

### Component Styles

**Buttons:**
- Height: 50sp (minimum)
- Border radius: 16r
- Font: 14sp, w600
- Primary: Purple background, white text
- Outline: Transparent background, divider border, colored text

**Text Fields:**
- Height: Auto
- Border radius: 16r
- Padding: 16sp
- Filled background (card color)
- Border: Divider color (default), primary color (focused), red (error)

**Cards:**
- Background: Card color
- Border radius: 16r
- Padding: 16sp horizontal, 12sp vertical

**Dialogs/Sheets:**
- Border radius: 16r (dialogs), top 16r (sheets)
- Padding: 16sp
- Background: Theme background color

---

## State Management & Dependency Injection

### GetX State Management

**Controller Pattern:**
```dart
class MyController extends GetxController {
  // State
  int _counter = 0;
  int get counter => _counter;

  // Methods
  void increment() {
    _counter++;
    update();  // Notify listeners
  }
}
```

**UI Binding:**
```dart
GetBuilder<MyController>(
  builder: (controller) {
    return Text('Count: ${controller.counter}');
  }
)
```

### Dependency Injection

**Global Dependencies (`get_di.dart`):**
```dart
// Core services (persist throughout app)
Get.lazyPut(() => SharedPreferences.getInstance());
Get.lazyPut(() => ApiClientImpl(...));

// Global controllers
Get.lazyPut(() => LocalizationController(...));  // Permanent
Get.lazyPut(() => ThemeController(...));         // Permanent
```

**Feature Bindings:**
```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut(() => FeatureRepoImpl(...));
    
    // Service
    Get.lazyPut(() => FeatureServiceImpl(...));
    
    // Controller (auto-disposed when screen closes)
    Get.lazyPut(() => FeatureController(...));
  }
}
```

**Registration:**
All feature bindings are registered in `get_di.dart`:
```dart
List<Bindings> bindings = [
  ThemeBinding(),
  LanguageBinding(),
  SplashBinding(),
  // Add new feature bindings here
];
```

**Controller Access:**
```dart
// Via Get.find
final controller = Get.find<MyController>();

// Via static getter (recommended)
class MyController extends GetxController {
  static MyController get find => Get.find<MyController>();
}

// Usage
MyController.find.someMethod();
```

---

## API Client Architecture

### Interface/Implementation Pattern

**Benefits:**
- **Testability:** Mock the interface for unit tests
- **Flexibility:** Swap implementations (e.g., use Dio instead of http)
- **Separation of concerns:** Controller → Service → Repository → API Client

### Flow Example

```dart
// 1. Controller calls service
class UserController extends GetxController {
  final UserService userService;
  
  Future<void> loadUsers() async {
    List<User> users = await userService.getUsers();
    update();
  }
}

// 2. Service calls repository
class UserServiceImpl implements UserService {
  final UserRepo userRepo;
  
  @override
  Future<List<User>> getUsers() async {
    Response? response = await userRepo.fetchUsers();
    if (response != null) {
      return parseUsers(response.body);
    }
    throw Exception("Failed to load users");
  }
}

// 3. Repository calls API client
class UserRepoImpl implements UserRepo {
  final ApiClient apiClient;
  
  @override
  Future<Response?> fetchUsers() async {
    return await apiClient.get('/users');
  }
}
```

### Error Handling

**Built-in handling in ApiClientImpl:**
- Network errors → Toast: "Please check your internet connection"
- API errors → Parse `ErrorResponse`, show first error message
- Unauthenticated → Show error, trigger logout

**Custom handling in service:**
```dart
try {
  Response? response = await repo.getData();
  if (response != null) {
    return parseData(response.body);
  }
} catch (e) {
  debugPrint('Error: $e');
  rethrow;  // Or handle gracefully
}
```

---

## Theme System

### Theme Switching

**Three modes:**
- **System** - Follow device theme
- **Light** - Always light
- **Dark** - Always dark

**Implementation:**
```dart
// In main.dart
GetMaterialApp(
  themeMode: themeController.themeMode,
  theme: light,
  darkTheme: dark,
  // ...
)

// Switch theme
ThemeController.find.setThemeMode(ThemeMode.dark);
```

### Theme-Aware Widgets

**Accessing theme:**
```dart
Theme.of(context).primaryColor
Theme.of(context).textTheme.bodyLarge
Theme.of(context).cardColor
```

**Design system colors:**
```dart
// Automatically adapts to theme
Container(color: Theme.of(context).cardColor)  // cardColorLight or cardColorDark
Text(style: Theme.of(context).textTheme.bodyMedium)  // Correct color
```

### Custom Theme Components

**To modify button theme:**
1. Edit `core/theme/src/elevated_button_theme.dart`
2. Changes apply to both light and dark themes
3. Rebuild app

**To add new theme component:**
1. Create `core/theme/src/my_component_theme.dart`
2. Export in `light_theme.dart` and `dark_theme.dart`
3. Add to `ThemeData()`

---

## Localization System

### How It Works

**1. Language Files**
```
assets/languages/
├── en.json
└── ar.json
```

**en.json:**
```json
{
  "language": "Language",
  "theme": "Theme",
  "system": "System",
  "dark": "Dark",
  "light": "Light"
}
```

**ar.json:**
```json
{
  "language": "لغة",
  "theme": "سمة",
  "dark": "مظلم"
}
```

**2. Load in `get_di.dart`:**
```dart
Future<Map<String, Map<String, String>>> _loadLanguages() async {
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in appLanguages) {
    String jsonStringValues = await rootBundle.loadString(
      'assets/languages/${languageModel.languageCode}.json'
    );
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
      mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }
  return languages;
}
```

**3. Configure in `main.dart`:**
```dart
GetMaterialApp(
  locale: localizeController.locale,
  translations: Messages(languages: languages),
  fallbackLocale: Locale('en', 'US'),
  // ...
)
```

**4. Use in UI:**
```dart
Text('language'.tr)  // Translates to current language
```

### Add New Language

**1. Add language to `appLanguages` in `language.dart`:**
```dart
List<LanguageModel> appLanguages = [
  LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
  LanguageModel(languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  LanguageModel(languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),  // New
];
```

**2. Create `assets/languages/es.json`:**
```json
{
  "language": "Idioma",
  "theme": "Tema",
  "dark": "Oscuro",
  "light": "Claro"
}
```

**3. Add flag image `assets/images/es.png`**

**4. Restart app** - Language will appear in selector

### RTL Support

**Automatic detection:**
```dart
bool _isLtr = _locale.languageCode != 'ar' && _locale.languageCode != 'fa';
```

**Usage:**
```dart
if (LocalizationController.find.isLtr) {
  // Left-to-right layout
} else {
  // Right-to-left layout
}
```

**Directional widgets:**
```dart
EdgeInsetsDirectional.only(start: 16)  // start = left in LTR, right in RTL
Align(alignment: AlignmentDirectional.centerStart)
```

---

## Configuration & Environment

### Android Configuration

**Centralized in `.env` file:**
```env
APP_NAME=Startup Repo
BUNDLE_ID_ANDROID=com.example.startupRepo
ANDROID_VERSION_CODE=1
ANDROID_VERSION_NAME=1.0
MIN_SDK_VERSION=24
TARGET_SDK_VERSION=34

KEYSTORE_PATH=keystore.jks
KEYSTORE_ALIAS=upload
KEYSTORE_PASSWORD=upload
KEY_PASSWORD=upload
```

**Loaded in `android/app/build.gradle.kts`:**
```kotlin
val env: Properties = Properties().apply {
    val envFile = File(rootProject.projectDir.parentFile, ".env")
    if (envFile.exists()) {
        FileInputStream(envFile).use { load(it) }
    }
}

android {
    defaultConfig {
        applicationId = env.getProperty("BUNDLE_ID_ANDROID")
        versionCode = env.getProperty("ANDROID_VERSION_CODE")?.toInt()
        resValue("string", "app_name", env.getProperty("APP_NAME"))
    }
}
```

### iOS Configuration

**Centralized in `ios/Flutter/Environment.xcconfig`:**
```
APP_NAME = Startup Repo
APP_VERSION = 1.0
BUILD_NUMBER = 1
BUNDLE_ID = com.example.startupRepo
```

**Imported in Debug.xcconfig and Release.xcconfig**

**Used in Info.plist:**
```xml
<key>CFBundleDisplayName</key>
<string>${MY_APP_NAME}</string>
```

### App Icon

**Update logo:**
1. Replace `assets/images/logo.png` with your logo (1024x1024)
2. Run: `dart run flutter_launcher_icons`
3. Icons generated for both Android and iOS

---

## Dependencies

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Flutter framework |
| `get` | ^4.7.2 | State management, DI, routing, localization |
| `http` | ^1.3.0 | HTTP client for API calls |
| `shared_preferences` | ^2.5.3 | Local key-value storage |
| `flutter_screenutil` | ^5.9.3 | Responsive UI (sp, r scaling) |

### UI Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `iconsax` | ^0.0.8 | Icon library |
| `shimmer` | ^3.0.0 | Shimmer loading effect |
| `cached_network_image` | ^3.4.1 | Cached image loading |
| `flutter_smart_dialog` | ^4.9.8+7 | Dialogs, toasts, loading overlays |

### Utility Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `intl` | ^0.20.2 | Internationalization |
| `url_launcher` | ^6.3.1 | Launch URLs, phone, email |
| `connectivity_plus` | ^6.1.3 | Network connectivity check |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Unit testing |
| `flutter_lints` | ^3.0.0 | Linting rules |
| `flutter_launcher_icons` | ^0.14.2 | Generate app icons |

### Commented (Firebase - Optional)

```yaml
# firebase_core: ^3.13.0
# firebase_analytics: any
# firebase_messaging: ^15.2.5
# firebase_crashlytics: ^4.3.5
# flutter_local_notifications: ^19.0.0
```

**To enable:** Uncomment in `pubspec.yaml` and run `flutter pub get`

---

## Widget Catalog

### Buttons

#### PrimaryButton
```dart
PrimaryButton(
  text: 'Submit',
  onPressed: () { },
  icon: Icon(Iconsax.tick_circle, size: 16.sp, color: Colors.white),
  color: primaryColor,      // Optional
  textColor: Colors.white,  // Optional
  radius: 16,               // Optional
)
```

#### PrimaryOutlineButton
```dart
PrimaryOutlineButton(
  text: 'Cancel',
  onPressed: () { },
  icon: Icon(Iconsax.close_circle, size: 16.sp),
  textColor: primaryColor,  // Optional
  radius: 16,               // Optional
)
```

### Input Fields

#### CustomTextField
```dart
CustomTextField(
  controller: emailController,
  labelText: 'Email Address',
  hintText: 'Enter your email',
  prefixIcon: Iconsax.sms,
  suffixIcon: Iconsax.eye,
  obscureText: false,
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Email is required';
    return null;
  },
  onChanged: (value) { },
)
```

#### CustomDropDown
```dart
CustomDropDown(
  labelText: 'Select Country',
  hintText: 'Choose one',
  items: [
    DropdownMenuItem(value: 'us', child: Text('United States')),
    DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
  ],
  onChanged: (value) { },
)
```

### Dialogs & Sheets

#### Confirmation Dialog
```dart
showConfirmationDialog(
  title: 'Delete Account',
  subtitle: 'This action cannot be undone. Are you sure?',
  actionText: 'Delete',
  onAccept: () {
    // Delete account logic
    pop();
  },
);
```

#### Confirmation Sheet
```dart
showConfirmationSheet(
  title: 'Logout',
  subtitle: 'Are you sure you want to logout?',
  actionText: 'Logout',
  onAccept: () {
    // Logout logic
    pop();
  },
);
```

### Loading & Feedback

#### Loading Overlay
```dart
// Show
showLoading();

// Hide
hideLoading();
```

#### Toast
```dart
showToast('Operation successful');
showToast('Error occurred');
```

#### Loading Widget
```dart
// For SmartDialog
FlutterSmartDialog.init(
  loadingBuilder: (string) => const LoadingWidget(),
)

// Inline
const Loading(size: 27)
```

### Images

#### Cached Network Image
```dart
PrimaryNetworkImage(
  url: 'https://example.com/image.jpg',
  fit: BoxFit.cover,
)
```
**Features:**
- Automatic caching
- Shimmer placeholder while loading
- Error placeholder (icon) on failure

#### Local Image
```dart
Image.asset(Images.logo)
```

### Effects

#### Shimmer
```dart
CustomShimmer(
  child: Container(
    width: 100,
    height: 100,
    color: Colors.grey[300],
  ),
)
```

---

## How to Add a New Feature

Follow the **Clean Architecture + Feature-First** pattern.

### Example: Adding a "Profile" Feature

#### Step 1: Create Directory Structure

```
lib/features/profile/
├── data/
│   ├── model/
│   │   └── profile_model.dart
│   └── repository/
│       ├── profile_repo.dart          (interface)
│       └── profile_repo_impl.dart     (implementation)
├── domain/
│   ├── binding/
│   │   └── profile_binding.dart
│   └── service/
│       ├── profile_service.dart       (interface)
│       └── profile_service_impl.dart  (implementation)
└── presentation/
    ├── controller/
    │   └── profile_controller.dart
    └── view/
        └── profile_screen.dart
```

#### Step 2: Create Model (`data/model/profile_model.dart`)

```dart
class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    avatar: json['avatar'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar': avatar,
  };
}
```

#### Step 3: Create Repository (`data/repository/`)

**profile_repo.dart** (interface):
```dart
import 'package:http/http.dart';

abstract class ProfileRepo {
  Future<Response?> getProfile();
  Future<Response?> updateProfile(Map<String, dynamic> data);
}
```

**profile_repo_impl.dart** (implementation):
```dart
import '../../../../core/api/api_client.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiClient apiClient;
  ProfileRepoImpl({required this.apiClient});

  @override
  Future<Response?> getProfile() async {
    return await apiClient.get('/profile');
  }

  @override
  Future<Response?> updateProfile(Map<String, dynamic> data) async {
    return await apiClient.put('/profile', data);
  }
}
```

#### Step 4: Create Service (`domain/service/`)

**profile_service.dart** (interface):
```dart
import '../../data/model/profile_model.dart';

abstract class ProfileService {
  Future<ProfileModel> getProfile();
  Future<bool> updateProfile(ProfileModel profile);
}
```

**profile_service_impl.dart** (implementation):
```dart
import 'dart:convert';
import 'package:http/http.dart';
import '../../data/model/profile_model.dart';
import '../../data/repository/profile_repo.dart';
import 'profile_service.dart';

class ProfileServiceImpl implements ProfileService {
  final ProfileRepo profileRepo;
  ProfileServiceImpl({required this.profileRepo});

  @override
  Future<ProfileModel> getProfile() async {
    Response? response = await profileRepo.getProfile();
    if (response != null && response.statusCode == 200) {
      return ProfileModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load profile');
  }

  @override
  Future<bool> updateProfile(ProfileModel profile) async {
    Response? response = await profileRepo.updateProfile(profile.toJson());
    return response != null && response.statusCode == 200;
  }
}
```

#### Step 5: Create Binding (`domain/binding/profile_binding.dart`)

```dart
import 'package:get/get.dart';
import '../../data/repository/profile_repo.dart';
import '../../data/repository/profile_repo_impl.dart';
import '../../presentation/controller/profile_controller.dart';
import '../service/profile_service.dart';
import '../service/profile_service_impl.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    ProfileRepo profileRepo = ProfileRepoImpl(apiClient: Get.find());
    Get.lazyPut(() => profileRepo);

    // Service
    ProfileService profileService = ProfileServiceImpl(profileRepo: Get.find());
    Get.lazyPut(() => profileService);

    // Controller (auto-disposed when screen closes)
    Get.lazyPut(() => ProfileController(profileService: Get.find()));
  }
}
```

#### Step 6: Create Controller (`presentation/controller/profile_controller.dart`)

```dart
import 'package:get/get.dart';
import '../../../core/widgets/snackbar.dart';
import '../../data/model/profile_model.dart';
import '../../domain/service/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService profileService;
  ProfileController({required this.profileService});

  static ProfileController get find => Get.find<ProfileController>();

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    update();
    
    try {
      _profile = await profileService.getProfile();
    } catch (e) {
      showToast('Failed to load profile');
    }
    
    _isLoading = false;
    update();
  }

  Future<void> updateProfile(ProfileModel profile) async {
    showLoading();
    try {
      bool success = await profileService.updateProfile(profile);
      if (success) {
        _profile = profile;
        showToast('Profile updated successfully');
        update();
      }
    } catch (e) {
      showToast('Failed to update profile');
    }
    hideLoading();
  }
}
```

#### Step 7: Create View (`presentation/view/profile_screen.dart`)

```dart
import 'package:startup_repo/imports.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: Loading());
          }

          if (controller.profile == null) {
            return const Center(child: Text('No profile data'));
          }

          return ListView(
            padding: AppPadding.padding16,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50.sp,
                  backgroundImage: controller.profile!.avatar != null
                    ? NetworkImage(controller.profile!.avatar!)
                    : null,
                  child: controller.profile!.avatar == null
                    ? Icon(Iconsax.user, size: 50.sp)
                    : null,
                ),
              ),
              SizedBox(height: 24.sp),
              Text('Name: ${controller.profile!.name}', 
                style: context.font16),
              SizedBox(height: 8.sp),
              Text('Email: ${controller.profile!.email}', 
                style: context.font14),
              SizedBox(height: 32.sp),
              PrimaryButton(
                text: 'Edit Profile',
                onPressed: () {
                  // Navigate to edit screen
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
```

#### Step 8: Register Binding in `get_di.dart`

```dart
List<Bindings> bindings = [
  ThemeBinding(),
  LanguageBinding(),
  SplashBinding(),
  ProfileBinding(),  // Add here
];
```

#### Step 9: Navigate to Screen

```dart
import 'package:startup_repo/features/profile/presentation/view/profile_screen.dart';

launchScreen(const ProfileScreen());
```

**Done!** Your feature is now integrated with the app architecture.

---

## How to Add a New API Endpoint

### Step 1: Add Endpoint to Constants

**`core/utils/app_constants.dart`:**
```dart
class AppConstants {
  static String appName = 'Startup Repo';
  static String baseUrl = 'https://api.example.com/';
  
  static const String configUrl = 'config';
  static const String loginUrl = 'auth/login';        // Add this
  static const String registerUrl = 'auth/register';  // Add this
  static const String usersUrl = 'users';             // Add this
}
```

### Step 2: Add Repository Method

**In your feature's repository implementation:**
```dart
class AuthRepoImpl implements AuthRepo {
  final ApiClient apiClient;

  @override
  Future<Response?> login(String email, String password) async {
    return await apiClient.post(
      AppConstants.loginUrl,
      {
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<Response?> register(Map<String, dynamic> data) async {
    return await apiClient.post(AppConstants.registerUrl, data);
  }
}
```

### Step 3: Add Service Method

**In your feature's service implementation:**
```dart
class AuthServiceImpl implements AuthService {
  final AuthRepo authRepo;

  @override
  Future<AuthResponse> login(String email, String password) async {
    Response? response = await authRepo.login(email, password);
    
    if (response != null && response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    
    throw Exception('Login failed');
  }
}
```

### Step 4: Call from Controller

```dart
class AuthController extends GetxController {
  final AuthService authService;

  Future<void> login(String email, String password) async {
    showLoading();
    
    try {
      AuthResponse response = await authService.login(email, password);
      
      // Save token
      await Get.find<SharedPreferences>().setString(
        SharedKeys.token,
        response.token,
      );
      
      // Update API client header
      Get.find<ApiClient>().updateHeader(response.token, 'en');
      
      // Navigate to home
      launchScreen(const HomeScreen(), pushAndRemove: true);
      
    } catch (e) {
      showToast('Login failed: ${e.toString()}');
    }
    
    hideLoading();
  }
}
```

### API Methods Reference

**GET:**
```dart
Response? response = await apiClient.get(
  'users',
  queryParams: {'page': '1', 'limit': '10'},
  headers: {'Custom-Header': 'value'},
);
```

**POST:**
```dart
Response? response = await apiClient.post(
  'users',
  {'name': 'John', 'email': 'john@example.com'},
  headers: {'Custom-Header': 'value'},
);
```

**PUT:**
```dart
Response? response = await apiClient.put(
  'users/123',
  {'name': 'John Updated'},
);
```

**DELETE:**
```dart
Response? response = await apiClient.delete('users/123');
```

**Download Image:**
```dart
Uint8List? imageBytes = await apiClient.downloadImage(
  'https://example.com/image.jpg',
);
```

---

## Best Practices

### 1. State Management
- Use `GetBuilder` for simple state updates
- Use `Obx` for reactive state (if you make variables `.obs`)
- Call `update()` after state changes in controllers
- Keep controllers focused (single responsibility)

### 2. Dependency Injection
- Register global dependencies in `get_di.dart`
- Use feature bindings for screen-specific dependencies
- Always use interfaces for testability
- Use `Get.lazyPut` for lazy loading, `Get.put` for immediate initialization

### 3. Code Organization
- One widget per file (for large widgets)
- Keep files under 300 lines
- Use meaningful names (`user_profile_screen.dart`, not `screen1.dart`)
- Group related files in folders

### 4. Design System
- Always use design system constants (`AppPadding`, `AppRadius`, `context.font16`)
- Avoid hard-coded values like `padding: EdgeInsets.all(16)` → use `AppPadding.padding16`
- Use theme colors via `Theme.of(context)` for theme switching support

### 5. Error Handling
- Always handle null responses from API
- Show user-friendly error messages
- Use try-catch in async operations
- Log errors for debugging (`debugPrint`)

### 6. Navigation
- Use `launchScreen()` helper for consistent animations
- Use `pushAndRemove: true` for logout/login flows
- Always import screen widgets, not route strings

### 7. Localization
- Use `.tr` for all user-facing strings
- Add translations to all language files
- Test with multiple languages
- Use descriptive keys (`'email_required'` not `'er1'`)

### 8. Performance
- Use `const` constructors where possible
- Avoid rebuilding entire screens (use `GetBuilder` on specific widgets)
- Cache network images (already handled by `PrimaryNetworkImage`)
- Dispose controllers properly (automatic with GetX bindings)

---

## Testing

### Unit Testing Controllers

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockProfileService extends Mock implements ProfileService {}

void main() {
  late ProfileController controller;
  late MockProfileService mockService;

  setUp(() {
    mockService = MockProfileService();
    controller = ProfileController(profileService: mockService);
  });

  test('loadProfile updates profile on success', () async {
    // Arrange
    final mockProfile = ProfileModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
    );
    when(mockService.getProfile()).thenAnswer((_) async => mockProfile);

    // Act
    await controller.loadProfile();

    // Assert
    expect(controller.profile, mockProfile);
    expect(controller.isLoading, false);
  });
}
```

---

## Troubleshooting

### Common Issues

**1. "Get.find() not found"**
- Ensure binding is registered in `get_di.dart`
- Call `Get.lazyPut` or `Get.put` before accessing

**2. Theme not updating**
- Ensure `update()` is called in ThemeController
- Check `GetMaterialApp` has `themeMode` bound to controller

**3. Translations not working**
- Check language JSON files exist in `assets/languages/`
- Verify key exists in JSON
- Ensure `.tr` is used on string

**4. API calls failing**
- Check `AppConstants.baseUrl` is correct
- Verify network connectivity
- Check API endpoint path
- Inspect console for error logs

**5. ScreenUtil not scaling**
- Ensure `ScreenUtilInit` wraps `GetMaterialApp`
- Use `.sp` for sizes, `.r` for radius, `.w/.h` for dimensions

---

## Deployment

### Android

**1. Update version in `.env`:**
```env
ANDROID_VERSION_CODE=2
ANDROID_VERSION_NAME=1.1.0
```

**2. Build release APK:**
```bash
flutter build apk --release
```

**3. Build App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

### iOS

**1. Update version in `ios/Flutter/Environment.xcconfig`:**
```
APP_VERSION = 1.1.0
BUILD_NUMBER = 2
```

**2. Build release:**
```bash
flutter build ios --release
```

**3. Archive in Xcode for App Store**

---

## Contributors

This boilerplate is designed to be extended. When adding features:
- Follow the established architecture
- Document new patterns in this file
- Update README.md with setup instructions
- Add unit tests for business logic

---

## License

[Add your license here]

---

**Last Updated:** 2024  
**Maintainer:** [Your Team]  
**Questions?** Check `development_flow.md` and `env.md` for additional setup details.
