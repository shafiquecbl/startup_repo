# Code Architecture Documentation for Pixart

## 1. Introduction

This document describes the code architecture for the Pixart image generation application. Our goal is to provide a scalable, maintainable, and modular structure using GetX for state management and dependency injection. The architecture follows a layered approach with clear separation of concerns among data, domain, and presentation layers.

The key components are:

- **Repository:** Handles raw data fetching and storage (API calls, local storage, etc.). It works with basic data types and models.
- **Service:** Contains business logic. It transforms raw data from the repository into domain models and applies necessary validations or calculations.
- **Controller:** Manages UI state and user interactions. It calls the service for data and updates the UI accordingly.
- **Bindings:** Define dependency injection for each feature, ensuring that controllers and services are instantiated only when needed.

This document also explains how to manage multiple controllers effectively—distinguishing global controllers (which persist throughout the app) from screen-specific controllers (which are disposed when the screen is closed).

---

## 2. Project Structure

Below is the updated directory structure for the project:

````
lib/
├── firebase_options.dart
├── imports.dart
├── main.dart
├── core/
│   ├── api/
│   │   ├── api_client.dart
│   │   └── api_client_interface.dart
│   ├── error/
│   │   ├── error.dart
│   │   └── together_ai_error.dart
│   ├── helper/
│   │   ├── get_di.dart              // Centralized dependency injection for core/global dependencies
│   │   ├── navigation.dart          // Navigation helpers
│   │   └── notification_helper.dart
│   ├── theme/
│   │   ├── dark_theme.dart
│   │   ├── light_theme.dart
│   │   └── src/
│   │       ├── appbar_theme.dart
│   │       ├── bottom_sheet_theme.dart
│   │       ├── dialog_theme.dart
│   │       ├── divider_theme.dart
│   │       ├── dropdown_theme.dart
│   │       ├── elevated_button_theme.dart
│   │       ├── icon_theme.dart
│   │       ├── input_decoration_theme.dart
│   │       ├── outline_button_theme.dart
│   │       ├── text_theme.dart
│   │       └── textbuton_theme.dart
│   ├── utils/
│   │   ├── app_constants.dart
│   │   ├── colors.dart
│   │   ├── images.dart
│   │   ├── messages.dart
│   │   ├── scroll_behavior.dart
│   │   └── style.dart
│   └── common/                    // Common reusable widgets (buttons, text fields, dialogs, etc.)\n│       ├── confirmation_dialog.dart\n│       ├── confirmation_sheet.dart\n│       ├── loading.dart\n│       ├── network_image.dart\n│       ├── primary_button.dart\n│       ├── shimmer.dart\n│       ├── snackbar.dart\n│       └── textfield.dart
├── features/
│   ├── home/
│   │   └── presentation/
│   │       └── view/
│   │           └── home.dart
│   ├── language/
│   │   ├── data/
│   │   │   ├── model/\n│   │   │   └── language.dart\n│   │   │\n│   │   └── repository/\n│   │       ├── localization_repo.dart\n│   │       └── localization_repo_interface.dart
│   │   ├── domain/
│   │   │   ├── binding/\n│   │   │   └── language_binding.dart\n│   │   │   └── service/\n│   │       ├── localization_service.dart\n│   │       └── localization_service_interface.dart
│   │   └── presentation/\n│       ├── controller/\n│       │   └── localization_controller.dart\n│       └── view/\n│           └── language.dart
│   ├── splash/
│   │   ├── data/\n│   │   ├── model/\n│   │   │   └── config_model.dart\n│   │   └── repository/\n│   │       ├── splash_repo.dart\n│   │       └── splash_repo_interface.dart
│   │   ├── domain/\n│   │   ├── binding/\n│   │   │   └── splash_binding.dart\n│   │   │   └── service/\n│   │       ├── splash_service.dart\n│   │       └── splash_service_interface.dart\n│   └── presentation/\n│       └── controller/\n│           └── splash_controller.dart
│   ├── theme/
│   │   ├── data/\n│   │   └── repository/\n│   │       ├── theme_repo.dart\n│   │       └── theme_repo_interface.dart\n│   ├── domain/\n│   │   ├── binding/\n│   │   │   └── theme_binding.dart\n│   │   └── service/\n│   │       ├── theme_service.dart\n│   │       └── theme_service_interface.dart\n│   └── presentation/\n│       └── controller/\n│           └── theme_controller.dart\n   \n   // ... Other feature directories (ads, background_remover, dashboard, history, home, html, inspirations, review, settings, subscription, tools, upscale_image, welcome, etc.)\n\n```\n\n## Detailed Explanation\n\n### Core Layer\n\n#### **API**\n- **Purpose:** Manage API communication (HTTP requests, responses, error handling).\n- **Files:** `api_client.dart`, `api_client_interface.dart`.\n\n#### **Error**\n- **Purpose:** Handle errors in a unified manner. Contains custom error classes such as `error.dart` and `together_ai_error.dart`.\n\n#### **Helper**\n- **Purpose:** Contains helper functions and classes for dependency injection (`get_di.dart`), navigation, and notifications.\n\n#### **Theme**\n- **Purpose:** Contains dark and light themes and their subcomponents for UI styling.\n\n#### **Utils**\n- **Purpose:** Houses utility files for constants, colors, images, messages, scroll behavior, and style.\n\n#### **Common**\n- **Purpose:** Contains reusable UI widgets used across multiple features (e.g., confirmation dialogs, primary buttons, shimmer, text fields).\n\n### Feature Layer\n\nEach feature is self-contained and follows a modular structure:\n\n#### **Data**\n- **Model:** Contains data models (DTOs) specific to the feature.\n- **Repository:** Manages data fetching from APIs or local storage. It only returns raw data which is then transformed by the service layer.\n\n#### **Domain**\n- **Binding:** Contains GetX bindings that handle dependency injection for that feature. This ensures controllers and services are only initialized when needed.\n- **Service:** Implements business logic, processes data from repositories, and transforms raw data into domain models. Use cases may be added here for complex business logic, but in our current architecture, services already provide that functionality.\n\n#### **Presentation**\n- **Controller:** Manages UI state and interacts with the service layer. There are two types:\n  - **Global Controllers:** Persist throughout the app (e.g., `SymptomsController`).\n  - **Screen-Specific Controllers:** Created when the screen is opened and disposed when closed (e.g., `LogSymptomsController`, `SymptomsViewController`).\n- **View:** Contains screens and widgets for UI, organized per feature.\n\n### Controller Management and Lifecycle\n\n- **Global Controllers:** Initialized at app startup (using `Get.put(..., permanent: true)`) and remain in memory.\n- **Screen-Specific Controllers:** Initialized via feature-specific bindings (using `Get.lazyPut()` or `Get.create()`) so they are created when the screen opens and disposed automatically when the screen is closed.\n\n#### **Best Practices for Controller Lifecycle**\n1. **Use Bindings:** Each feature should have a binding class (e.g., `SymptomsBinding`, `LogSymptomsBinding`) that registers its controllers, services, and repositories.\n2. **Global vs. Local:** Use `Get.put()` for controllers that need to persist, and `Get.lazyPut()` or `Get.create()` for those only needed while a screen is active.\n3. **Avoid Cross-Controller Dependencies:** If a screen-specific controller is needed by a global controller, consider either making it persistent or refactoring its logic into a service so that the global controller doesn’t depend on a transient controller.\n4. **Centralize Dependency Injection:** Use a dedicated dependency injection file (e.g., `get_di.dart` or `initial_binding.dart`) to register global dependencies, while feature-specific bindings handle local ones.\n\n### Flow Between Layers\n\n1. **UI (View)** triggers an action (e.g., log symptoms) → calls the corresponding **Controller**.\n2. The **Controller** calls the **Service** for business logic (e.g., formatting data, validating input).\n3. The **Service** interacts with the **Repository** to fetch or store data.\n4. The **Repository** communicates with APIs or local storage and returns raw data.\n5. The **Service** transforms the raw data into domain models and returns them to the **Controller**.\n6. The **Controller** updates the UI accordingly.\n\n### Example: Logging Symptoms\n\n- **SymptomsController (Global):**\n  - Fetches the full list of symptoms from the backend.\n  - Provides methods for logging symptoms and retrieving logged data by date or month.\n\n- **LogSymptomsController (Screen-Specific):**\n  - Manages UI state such as the selected date, search query, and the initialization of logged data for a given date.\n  - Retrieves logged data using `SymptomsController` and then updates local state (weight, temperature, notes, etc.).\n  - On logging, it calls `SymptomsController.logSymptoms(...)` to send data to the backend.\n\n- **SymptomSelectionController (Screen-Specific):**\n  - Manages which symptoms are selected in the UI.\n  - Provides methods to toggle, initialize, and clear symptom selections.\n\n- **HealthMetricsControllers (Optional):**\n  - If necessary, separate controllers can handle weight, temperature, and notes for finer control.\n\n### Managing Multiple Controllers\n\nBecause different controllers serve different purposes (global vs. screen-specific), it’s important to:\n\n- **Clearly Label and Document Each Controller:**\n  - For example, annotate `SymptomsController` as _global_ and `LogSymptomsController` as _screen-specific_.\n\n- **Use Feature Bindings:**\n  - Ensure that screen-specific controllers are registered in a feature binding so that they are automatically disposed when the screen is closed.\n\n- **Minimize Cross-Controller Dependencies:**\n  - If a screen-specific controller is used inside a global controller, either refactor its logic into a service or use persistent instances with `Get.put()`.\n\n- **Centralize Global Controller Initialization:**\n  - Use an initial binding for global controllers in `main.dart` to avoid cluttering screen-specific bindings.\n\n### Dependency Injection Example\n\nIn `get_di.dart`, register global dependencies:\n\n```dart\n// Core dependencies\nfinal sharedPreferences = await SharedPreferences.getInstance();\nGet.lazyPut(() => sharedPreferences);\nApiClientInterface apiClient = ApiClient(sharedPreferences: Get.find(), baseUrl: AppConstants.baseUrl);\nGet.lazyPut(() => apiClient);\n\n// Global repositories\nLocalizationRepoInterface localizationRepo = LocalizationRepo(prefs: Get.find());\nGet.lazyPut(() => localizationRepo);\nThemeRepoInterface themeRepo = ThemeRepo(prefs: Get.find());\nGet.lazyPut(() => themeRepo);\nSplashRepoInterface splashRepo = SplashRepo(apiClient: Get.find(), prefs: Get.find());\nGet.lazyPut(() => splashRepo);\n\n// Global services\nLocalizationServiceInterface localizationService = LocalizationService(localizationRepo: Get.find());\nGet.lazyPut(() => localizationService);\nThemeServiceInterface themeService = ThemeService(themeRepo: Get.find());\nGet.lazyPut(() => themeService);\nSplashServiceInterface splashService = SplashService(splashRepo: Get.find());\nGet.lazyPut(() => splashService);\n\n// Global controllers\nGet.put(() => LocalizationController(localizationService: Get.find()), permanent: true);\nGet.put(() => ThemeController(themeService: Get.find()), permanent: true);\n```\n\nFor feature-specific controllers, create a binding per feature. For example, for logging symptoms:\n\n```dart\nclass LogSymptomsBinding extends Bindings {\n  @override\n  void dependencies() {\n    Get.lazyPut(() => LogSymptomsController());\n    Get.lazyPut(() => SymptomSelectionController());\n    // Optionally, if using separate health metrics controllers\n    // Get.lazyPut(() => WeightController());\n    // Get.lazyPut(() => TemperatureController());\n    // Get.lazyPut(() => NotesController());\n  }\n}\n```\n\nThen, in your routing (or manually in `initState` if not using named routes):\n\n```dart\nGetPage(\n  name: '/logSymptoms',\n  page: () => LogSymptomsScreen(),\n  binding: LogSymptomsBinding(),\n);\n```\n\n### Conclusion\n\nThe updated architecture is designed to:\n\n- **Maintain a clear separation of concerns:** Data fetching is handled by repositories, business logic by services, and UI state by controllers.\n- **Support scalability:** New features can be added without disrupting existing functionality.\n- **Simplify controller management:** Global controllers persist across the app, while screen-specific controllers are disposed automatically when the screen is closed.\n- **Be understandable for junior developers:** With a consistent approach using bindings and centralized dependency injection, the project remains organized and maintainable.\n\nThis document should guide the team to follow best practices in managing dependencies, controller lifecycles, and separation of concerns. \n\nFeel free to adjust details as needed to match any further refinements in your project. \n\n---\n\n*Document Version: 1.1 - Updated to reflect new architecture decisions and best practices based on team discussions.*\n"}

Below is an updated, detailed architecture document for your Pixart application. This document is intended to guide your team in understanding the code structure, the responsibilities of each layer, and how to manage controllers (global vs. screen-specific) effectively.

---

# Code Architecture Documentation for Pixart

## 1. Introduction

This document outlines the architecture of the Pixart image generation application. It explains the purpose of each folder, the flow between repositories, services, and controllers, and best practices for dependency management and controller lifecycles. This guide is designed to help all developers—even juniors—understand and work with the project consistently.

**Key Objectives:**

- **Separation of Concerns:** Distinct layers for data, domain, and presentation.
- **Scalability:** New features can be added without modifying existing code.
- **Maintainability:** Controllers, services, and repositories are isolated for easier testing and debugging.
- **Effective Controller Lifecycle Management:** Global controllers persist across the app, while screen-specific controllers are initialized on demand and disposed when the screen is closed.

---

## 2. Project Structure

The project is organized into two main sections: **core** and **features**.

### Core Layer

Contains reusable components and utilities that are shared across the entire application.

````

lib/
├── core/
│ ├── api/ // API client classes for HTTP requests\n│ │ ├── api_client.dart\n│ │ └── api_client_interface.dart
│ ├── error/ // Error handling classes (custom errors, etc.)
│ ├── helper/ // Helper functions & dependency injection (e.g., get_di.dart, navigation, notification_helper)\n ├── get_di.dart\n ├── navigation.dart\n └── notification_helper.dart
│ ├── theme/ // Theme definitions (dark, light, and sub-themes for UI components)\n ├── dark_theme.dart\n ├── light_theme.dart\n └── src/...\n └── textbuton_theme.dart
│ ├── utils/ // Utility functions, constants, colors, images, messages, styles\n ├── app_constants.dart\n ├── colors.dart\n ├── images.dart\n ├── messages.dart\n ├── scroll_behavior.dart\n └── style.dart
│ └── common/ // Common reusable widgets (confirmation dialogs, buttons, loading indicators, etc.)\n ├── confirmation_dialog.dart\n ├── confirmation_sheet.dart\n ├── loading.dart\n ├── network_image.dart\n ├── primary_button.dart\n ├── shimmer.dart\n ├── snackbar.dart\n └── textfield.dart

```

### Features Layer

Each feature is a self-contained module that follows a modular structure with separate layers.

```

lib/
└── features/
├── home/ // Home screen feature\n │ └── presentation/\n │ └── view/\n │ └── home.dart
├── language/ // Language selection feature\n │ ├── data/\n │ │ ├── model/ (e.g., language.dart)\n │ │ └── repository/ (e.g., localization_repo.dart)\n │ ├── domain/\n │ │ ├── binding/ (language_binding.dart)\n │ │ └── service/ (localization_service.dart)\n │ └── presentation/\n │ ├── controller/ (localization_controller.dart)\n │ └── view/ (language.dart)\n ├── splash/ // Splash screen feature (startup configuration)\n ├── theme/ // Theme-related features\n └── ... // Other features (ads, background_remover, history, upscale_image, etc.)\n\nEach feature follows the pattern:\n\nfeature_name/\n├── data/\n│ ├── model/ // Data models (DTOs)\n│ └── repository/ // Repositories (data fetching from API/local storage)\n├── domain/\n│ ├── binding/ // GetX bindings (dependency injection for the feature)\n│ └── service/ // Business logic (data processing, validation, transformation)\n└── presentation/\n ├── controller/ // Controllers (manages UI state, user interactions)\n └── view/ // UI screens and feature-specific widgets\n └── widgets/ // Reusable components specific to the feature\n```

---

## 3. Detailed Layer Responsibilities

### 3.1 Data Layer

- **Model:** Contains data structures that mirror API responses or represent local data.
- **Repository:** Handles all data operations (API calls, local storage). It accepts raw data (e.g., JSON) and returns it to the service layer. The repository does not include any business logic.

### 3.2 Domain Layer

- **Binding:** Contains GetX bindings that register dependencies (repositories, services, controllers) for the feature. This ensures that controllers and services are only created when needed.
- **Service:** Implements the business logic. It interacts with the repository to fetch data, applies validations or transformations, and then returns domain models to the controller. (For many features, the service layer itself acts as a use case, so separate use case classes are not necessary unless the business logic is very complex.)

### 3.3 Presentation Layer

- **Controller:** Manages UI state and user interactions. It calls methods on the service layer to fetch or update data. There are two kinds of controllers:
  - **Global Controllers:** These persist throughout the app (e.g., `SymptomsController`). They are initialized in a global binding and remain in memory.
  - **Screen-Specific Controllers:** These are created when a particular screen is shown (e.g., `LogSymptomsController`, `SymptomsViewController`). They are registered using feature bindings so that they are disposed automatically when the screen is closed.
- **View:** Contains the UI code. Views use GetX (e.g., `GetBuilder`, `Obx`) to rebuild based on controller updates.

---

## 4. Flow Between Layers

1. **User Interaction:** The user performs an action on the UI (View).
2. **Controller:** The corresponding controller is triggered, which calls a method on the service.
3. **Service:** The service processes the request, interacts with the repository, and applies business logic.
4. **Repository:** The repository makes API calls or reads local data, returning raw data.
5. **Service:** The service transforms raw data into domain models.
6. **Controller:** The controller receives the domain models, updates its state, and triggers a UI update.
7. **UI (View):** The UI rebuilds based on the updated state.

---

## 5. Managing Multiple Controllers

### Global vs. Screen-Specific Controllers

- **Global Controllers:**

  - Example: `SymptomsController`
  - Initialized using `Get.put(..., permanent: true)` or in a global binding.
  - Remains in memory across the app's lifetime.

- **Screen-Specific Controllers:**
  - Example: `LogSymptomsController`, `SymptomsViewController`, and any controller for a bottom sheet or dialog.
  - Registered using feature-specific bindings (e.g., `LogSymptomsBinding`).
  - Automatically disposed when the associated screen is removed from the navigation stack.

### Best Practices for Controller Management

1. **Use Feature-Specific Bindings:**  
   Create a binding for each feature that registers the controllers, services, and repositories. For example:

   ```dart
   class LogSymptomsBinding extends Bindings {
     @override
     void dependencies() {
       Get.lazyPut<LogSymptomsController>(() => LogSymptomsController(initialDate: DateTime.now())); // Screen-specific
       Get.lazyPut<SymptomSelectionController>(() => SymptomSelectionController()); // Screen-specific
     }
   }
   ```

   Then, attach this binding in your route or when navigating to the feature.

2. **Centralize Global Controllers:**  
   Global controllers should be initialized in a central file (e.g., `get_di.dart` or an `InitialBinding`) and marked as permanent:

   ```dart
   Get.put(SymptomsController(symptomsService: MySymptomsService()), permanent: true);
   ```

3. **Avoid Cross-Controller Dependencies:**  
   If a global controller depends on a screen-specific controller, either refactor the shared logic into a service or ensure the dependent controller is not disposed when the screen closes.

4. **Clear Documentation and Naming:**
   - Name controllers clearly (e.g., `SymptomsController` for global, `LogSymptomsController` for the log screen).\n - Document in comments which controllers are global and which are screen-specific.\n - Explain the lifecycle in your team's documentation.

---

## 6. Dependency Injection Strategy

### Global Dependency Injection

- Use a centralized dependency injection file (`get_di.dart`) to register core dependencies (e.g., API client, SharedPreferences, global repositories, global services, and global controllers).
- Example:

  ```dart
  // get_di.dart
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  ApiClientInterface apiClient = ApiClient(sharedPreferences: Get.find(), baseUrl: AppConstants.baseUrl);
  Get.lazyPut(() => apiClient);

  // Global repositories and services
  LocalizationRepoInterface localizationRepo = LocalizationRepo(prefs: Get.find());
  Get.lazyPut(() => localizationRepo);
  LocalizationServiceInterface localizationService = LocalizationService(localizationRepo: Get.find());
  Get.lazyPut(() => localizationService);

  // Global controllers
  Get.put(LocalizationController(localizationService: Get.find()), permanent: true);
  ```

### Feature-Specific Dependency Injection

- For each feature, create a Binding class that registers feature-specific dependencies.
- Example (for Log Symptoms):
  ```dart
  class LogSymptomsBinding extends Bindings {
    @override
    void dependencies() {
      Get.lazyPut<LogSymptomsController>(() => LogSymptomsController(initialDate: DateTime.now())); // Screen-specific\n      Get.lazyPut<SymptomSelectionController>(() => SymptomSelectionController()); // Screen-specific\n    }\n  }
  ```
- Attach these bindings in your routes so that the controllers are created only when the feature is accessed.

---

## 7. Summary

- **Repository:** Handles data access and retrieval. It only deals with raw data formats.
- **Service:** Contains business logic and transforms raw data into domain models. It interacts with the repository.
- **Controller:** Manages UI state and handles user interactions. Global controllers persist across the app, while screen-specific controllers are disposed automatically when the screen is closed.
- **Bindings:** Provide a mechanism for dependency injection, ensuring that feature-specific controllers and services are created only when needed and disposed automatically.

**Managing Multiple Controllers:**

- **Global Controllers** are initialized centrally and are permanent.
- **Screen-Specific Controllers** are registered via feature bindings (using `Get.lazyPut()` or `Get.create()`) and are disposed automatically when the screen is removed.
- **Clear documentation and naming conventions** help the team understand which controllers persist and which are transient.

This updated architecture should help maintain consistency, scalability, and ease of maintenance across the project, making it easier for junior developers to follow best practices.

---

_Document Version: 2.0 - Updated to reflect new architectural decisions and best practices based on team feedback and ongoing discussions._
