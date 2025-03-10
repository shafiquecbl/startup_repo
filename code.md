# Code Architecture Documentation for Startup_Repo

## 1. Introduction

This document describes the code architecture for the **Startup_Repo** Flutter project. Our aim is to build a scalable, maintainable, and modular codebase by clearly separating concerns among data handling, business logic, and UI state management. We use GetX for state management and dependency injection.

**Key Objectives:**

- **Separation of Concerns:** Clearly divide the code into Data, Domain, and Presentation layers.
- **Modularity:** Each feature is self-contained, making it easy to add or modify functionality.
- **Maintainability:** Use a consistent DI strategy and controller management to help all team members (especially juniors) understand and work with the code.
- **Scalability:** Ensure that global dependencies persist while screen-specific controllers are created and disposed automatically.

---

## 2. Project Structure

The project is organized into two primary sections: **core** and **features**.

### 2.1 Core Layer

The `core` directory contains shared resources and utilities that are used across the entire application.

```
lib/
└── core/
    ├── api/
    │   ├── api_client.dart
    │   └── api_client_interface.dart
    ├── error/
    │   └── error.dart
    ├── helper/
    │   ├── get_di.dart              // Central DI file for core dependencies
    │   ├── navigation.dart          // Navigation helper functions
    │   └── notification_helper.dart // Notification utilities
    ├── theme/
    │   ├── dark_theme.dart
    │   ├── light_theme.dart
    │   └── src/
    │       ├── appbar_theme.dart
    │       ├── bottom_sheet_theme.dart
    │       ├── dialog_theme.dart
    │       ├── divider_theme.dart
    │       ├── dropdown_theme.dart
    │       ├── elevated_button_theme.dart
    │       ├── icon_theme.dart
    │       ├── input_decoration_theme.dart
    │       ├── outline_button_theme.dart
    │       ├── text_theme.dart
    │       └── text_button_theme.dart
    ├── utils/
    │   ├── app_constants.dart
    │   ├── colors.dart
    │   ├── images.dart
    │   ├── messages.dart
    │   └── style.dart
    └── common/
        ├── confirmation_dialog.dart
        ├── loading.dart
        ├── primary_button.dart
        ├── shimmer.dart
        ├── snackbar.dart
        └── textfield.dart
```

**Explanation of Core Subfolders:**

- **api:**  
  Contains classes and interfaces for API communication.

- **error:**  
  Provides centralized error handling and custom error classes.

- **helper:**  
  Includes dependency injection (DI) management (in `get_di.dart`), navigation helpers, and notification utilities.

- **theme:**  
  Defines the application’s dark and light themes along with specific UI element themes (e.g., app bar, buttons).

- **utils:**  
  Houses application-wide constants, color schemes, image references, messages, and styles.

- **common:**  
  Contains reusable widgets such as dialogs, loading indicators, buttons, and text fields that can be used in multiple features.

---

### 2.2 Features Layer

Each feature is a self-contained module with its own data, domain, and presentation subdirectories.

```
lib/
└── features/
    ├── home/
    │   └── presentation/
    │       └── view/
    │           └── home.dart
    ├── language/
    │   ├── data/
    │   │   ├── model/
    │   │   │   └── language.dart
    │   │   └── repository/
    │   │       ├── localization_repo.dart
    │   │       └── localization_repo_interface.dart
    │   ├── domain/
    │   │   ├── binding/
    │   │   │   └── language_binding.dart
    │   │   └── service/
    │   │       ├── localization_service.dart
    │   │       └── localization_service_interface.dart
    │   └── presentation/
    │       ├── controller/
    │       │   └── localization_controller.dart
    │       └── view/
    │           └── language.dart
    ├── splash/
    │   ├── data/
    │   │   ├── model/
    │   │   │   └── config_model.dart
    │   │   └── repository/
    │   │       ├── splash_repo.dart
    │   │       └── splash_repo_interface.dart
    │   ├── domain/
    │   │   ├── binding/
    │   │   │   └── splash_binding.dart
    │   │   └── service/
    │   │       ├── splash_service.dart
    │   │       └── splash_service_interface.dart
    │   └── presentation/
    │       └── controller/
    │           └── splash_controller.dart
    ├── theme/
    │   ├── data/
    │   │   └── repository/
    │   │       ├── theme_repo.dart
    │   │       └── theme_repo_interface.dart
    │   ├── domain/
    │   │   ├── binding/
    │   │   │   └── theme_binding.dart
    │   │   └── service/
    │   │       ├── theme_service.dart
    │   │       └── theme_service_interface.dart
    │   └── presentation/
    │       └── controller/
    │           └── theme_controller.dart
    └── ...   // Other features follow a similar structure.
```

**Explanation of Feature Subfolders:**

- **data:**

  - **model:** Contains data models (DTOs) used in the feature.
  - **repository:** Manages data fetching from APIs or local storage.

- **domain:**

  - **binding:** Registers the feature’s dependencies (repositories, services, controllers) via GetX Bindings.
  - **service:** Implements business logic and data transformation. In many cases, the service layer covers what might otherwise be separate use cases.

- **presentation:**
  - **controller:** Manages UI state for the feature. There are two types:
    - **Global Controllers:** Persist across the app (e.g., LocalizationController, ThemeController).
    - **Screen-Specific Controllers:** Created via feature bindings and disposed automatically when the screen is closed.
  - **view:** Contains screens and widgets that compose the user interface.

---

## 3. Layer Responsibilities and Flow

### 3.1 Data Layer

- **Model:** Defines the structure of data used within the app.
- **Repository:** Handles all data operations (API calls, local storage). It is solely responsible for data access and does not implement business logic.

### 3.2 Domain Layer

- **Binding:** Each feature has its own binding (e.g., `SplashBinding`, `LanguageBinding`) which registers the feature’s controllers, services, and repositories using GetX. This ensures dependencies are injected only when needed and disposed automatically when the feature is closed.
- **Service:** Implements the business logic for the feature. It transforms raw data from repositories into domain models and applies any necessary validations or processing. For simpler features, the service layer covers what might otherwise be separate use cases.

### 3.3 Presentation Layer

- **Controller:** Manages UI state and user interactions. Controllers call services for business logic and update the UI accordingly. Global controllers (e.g., LocalizationController) are permanent, while screen-specific controllers (e.g., those used only in a splash screen) are disposed automatically.
- **View:** Contains the UI code (screens, widgets) and subscribes to controller updates via GetX’s state management tools like `GetBuilder` or `Obx`.

### Flow Between Layers

1. **UI (View):** The user interacts with the app (e.g., taps a button).
2. **Controller:** The corresponding controller is triggered and calls a method in the service layer.
3. **Service:** The service processes the request, interacting with the repository to fetch or store data.
4. **Repository:** The repository performs API calls or local storage operations and returns raw data.
5. **Service:** The service transforms the raw data into domain models and returns it to the controller.
6. **Controller:** The controller updates its state, causing the UI to rebuild with the new data.

---

## 4. Dependency Injection Strategy

### Feature-Specific DI with Central Registration

Our DI strategy is based on **feature-specific bindings** that are centrally registered. This ensures that each feature’s dependencies are isolated and only loaded when required.

#### **Central Registration in `get_di.dart`**

```dart
Future<Map<String, Map<String, String>>> init() async {
  // Core dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  ApiClientInterface apiClient = ApiClient(
    sharedPreferences: Get.find(),
    baseUrl: AppConstants.baseUrl,
  );
  Get.lazyPut(() => apiClient);

  // Feature-specific bindings (Central Registration)
  List<Bindings> bindings = [
    ThemeBinding(),
    LanguageBinding(),
    SplashBinding(),
    // Add additional feature bindings here...
  ];

  for (Bindings binding in bindings) {
    binding.dependencies();
  }

  // Retrieve localized languages
  return await _loadLanguages();
}

Future<Map<String, Map<String, String>>> _loadLanguages() async {
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle.loadString(
      'assets/languages/${languageModel.languageCode}.json',
    );
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }
  return languages;
}
```

**Explanation:**

- Core dependencies (e.g., SharedPreferences and ApiClient) are registered globally.
- Feature-specific bindings (e.g., ThemeBinding, LanguageBinding, SplashBinding) are stored in a list and iterated over to call their `dependencies()` methods.
- This central registration ensures that each feature’s DI is isolated and manageable.

---

## 5. Controller Lifecycle Management

### Global Controllers

- **Purpose:** Manage app-wide state (e.g., LocalizationController, ThemeController).
- **Initialization:** Registered using `Get.put(..., permanent: true)` in the global DI file.
- **Lifetime:** Persist throughout the app session.

### Screen-Specific Controllers

- **Purpose:** Manage transient state for individual screens (e.g., controllers for splash screens, dialogs, etc.).
- **Initialization:** Registered in feature-specific bindings using `Get.lazyPut()` or `Get.create()`.
- **Lifetime:** Automatically created when the screen is accessed and disposed when the screen is closed.

**Best Practices:**

- Use **feature bindings** to encapsulate screen-specific controller initialization.
- Avoid cross-dependencies between global and screen-specific controllers; if sharing logic is needed, refactor it into a service.
- Clearly document and name controllers to indicate their intended lifecycle.

---

## 6. Flow Example: Splash Feature

**SplashBinding (Domain Layer):**

```dart
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    SplashRepoInterface splashRepoInterface = SplashRepo(
      prefs: Get.find(),
      apiClient: Get.find(),
    );
    Get.lazyPut(() => splashRepoInterface);

    // Service
    SplashServiceInterface splashServiceInterface = SplashService(
      splashRepo: Get.find(),
    );
    Get.lazyPut(() => splashServiceInterface);

    // Controller (Screen-Specific)
    Get.lazyPut(() => SplashController(splashService: Get.find()));
  }
}
```

**Global Dependency Injection (get_di.dart):**

- See the central registration snippet above.

---

## 7. Summary

- **Data Layer:**  
  Contains models and repositories that handle raw data access without business logic.

- **Domain Layer:**  
  Contains bindings (for DI) and services that implement business logic and data transformation.

- **Presentation Layer:**  
  Contains controllers that manage UI state and views that display data. Global controllers persist, while screen-specific controllers are automatically disposed.

- **Dependency Injection:**  
  We use feature-specific DI with central registration in `get_di.dart` to ensure a modular and manageable setup. Each feature registers its own controllers, services, and repositories via its binding.

- **Controller Lifecycle:**  
  Global controllers are initialized once and persist, whereas screen-specific controllers are registered through bindings and disposed when their screen is closed.
