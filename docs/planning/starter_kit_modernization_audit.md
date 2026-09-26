# Flutter Starter Kit Modernization Audit

> Historical audit. Its API/session/retry design and typed repository decoding were superseded by the reviewed minimal
> client documented in `docs/api_client.md`.

**Date:** 2026-09-15
**Scope:** `startup_repo` baseline, `soani_mobile_app` comparison, current Flutter template, and current official guidance.

## Outcome

The starter has a useful feature-first structure and design-system foundation, but it is not a safe current-stable
template yet. The first implementation pass must fix secrets, toolchain drift, API failure UX, transport concurrency,
and verification. UI package replacement and widget organization should follow in the same migration, before the
agent rules are updated.

## Progress Update — 2026-09-15

All seven phases are complete. The testing-only tracked `.env` was removed without credential rotation or Git-history
rewriting. The starter now uses Flutter 3.47.2/Dart 3.13.2, Android API 36/modern Gradle tooling, iOS 15/UIScene/SwiftPM,
typed Dio failures and selective feedback, secure sessions, verified connectivity, Toastification, semantic Hugeicons,
organized core widgets, strict analysis, accessibility checks, sanitized uncaught-error hooks, pinned CI, and automated
APK/AAB 16 KB verification. See `docs/release_baseline.md` for artifact results and the remaining manual device gate.

## Verified Baseline

| Area | Current result |
| --- | --- |
| Machine stable Flutter | 3.47.2 / Dart 3.13.2 |
| Project FVM pin | 3.38.3 |
| Dart SDK constraint | `^3.10.1` |
| Static analysis | 2 issues: one removed lint and one style info |
| Tests | Fail: stale counter test; app DI is not initialized |
| Android compile SDK | 36 |
| Android target SDK | 34 from tracked `.env`; Gradle fallback is 35 |
| Android NDK | 27.0.12077973 |
| iOS deployment target | Xcode project 12.0; Podfile 13.0 |
| iOS dependency manager | CocoaPods |
| SwiftPM integration | Missing |
| UIScene migration | Missing |
| CI | Missing |
| Effective test coverage | Zero |

## Critical Findings

### 1. Tracked signing secrets

- `.env` is tracked by Git and contains Android signing fields.
- `.gitignore` does not ignore `.env` or Android signing property files.
- `android/app/build.gradle.kts:14-22` makes the tracked `.env` mandatory during Gradle configuration.
- Removing the file from the latest commit is insufficient if real values existed in history.

Required treatment:

1. Move non-secret Android identity values to tracked `android/app/app_config.properties`.
2. Move signing values to ignored `android/app/signing.properties` and CI secret storage.
3. Read API base URLs through validated `String.fromEnvironment` values supplied by `--dart-define`.
4. Keep iOS display name/version/bundle configuration in tracked xcconfig only when it contains no secret.
5. Rotate any real keystore credentials that were committed.
6. Decide separately whether Git history must be purged. Do not rewrite shared history silently.

### 2. API client has unsafe behavior

`lib/core/api/api_client_impl.dart` has these specific defects:

- L13: declares a 120-second timeout but never applies it.
- L20 and L58: one mutable client slot is overwritten by concurrent calls.
- L37-41: cancellation closes whichever request last replaced the shared client.
- L58 and L81-83: creates a client per request, then only nulls the reference; normal completion does not close it.
- L50-52: treats a network interface as proof that the API is reachable.
- L105-107: logs full headers and request bodies, including bearer tokens and user data.
- L117-125: every HTTP failure triggers presentation side effects.
- L121: session expiry depends on matching the English text `Unauthenticated` instead of status/backend code.
- L128-137: timeout, cancellation, decoding, TLS/DNS, and unknown failures collapse into generic strings.
- `ApiResult` retains only message/status and cannot carry field errors, trace ID, retryability, or retry delay.

### 3. Startup failure UX floods users

- GET/read failures, background calls, startup fan-out, mutations, and polling all use the same toast behavior.
- Offline checks can open a global SmartDialog before every request.
- Multiple independent failures compete for attention instead of producing one page/banner state.

Required policy:

- GET/HEAD default = silent. Screen renders loading, inline error, empty, and retry states.
- User-triggered POST/PUT/PATCH/DELETE default = one error toast.
- Background/startup mutation = explicitly silent.
- Exceptional foreground read = explicitly requests toast.
- Cancellation = always silent.
- Parallel 401 responses = one coalesced session-expired action.
- Identical visible toast messages = deduplicated for a short window.
- Startup orchestrator = one aggregate error state, never N transport toasts.

## Target API Foundation

Use one long-lived Dio transport behind the existing repository/service architecture.

```text
Repository -> ApiRequest<T> -> ApiClient.execute<T>() -> ApiResult<T>
                                      |
                                      +-> immutable session headers
                                      +-> typed decoding
                                      +-> finite timeouts
                                      +-> per-request cancellation
                                      +-> error/failure mapping
                                      +-> coalesced 401 handling
                                      +-> injected feedback policy
```

Core types:

- `ApiRequest<T>`: method, path, decoder, query, data, headers, auth requirement, feedback policy, cancel token,
  optional timeout override, and optional idempotency metadata only when needed.
- `ApiResult<T>`: typed `Success<T>` or `Failure<T>`.
- `ApiFailure`: kind, status, backend code/message, validation field errors, trace/request ID, retry-after value,
  and retry eligibility.
- `ApiFailureKind`: network, timeout, cancelled, badRequest, unauthenticated, forbidden, notFound, conflict,
  validation, rateLimited, server, decoding, and unknown.
- `ApiSession`: immutable in-memory access token and language. The starter does not persist credentials.

Transport rules:

- One Dio instance. Do not create one transport per request.
- Default finite connect/send/receive timeouts. Allow endpoint override for upload/download/stream cases.
- No automatic mutation retry. Retry only approved idempotent operations with bounded exponential backoff and
  jitter. Honor `Retry-After` for 429/503 when present.
- Never log bearer tokens, cookies, authorization headers, raw private bodies, or document/media payloads.
- Do not disable TLS verification. Certificate pinning is optional and requires an operational rotation plan.
- Decode at the repository boundary so controllers never handle Dio responses or `jsonDecode`.
- Keep cache/offline behavior outside the generic transport. Repositories own feature-specific cache policy.

## Toolchain and Native Migration

### Flutter/Dart

- Pin Flutter 3.47.2 exactly in `.fvmrc`.
- Update the Dart constraint to `^3.13.2`.
- Review Flutter 3.41/3.44/3.47 breaking changes before changing application code.
- Upgrade direct dependencies to the newest stable versions resolvable by the pin, then review every major.

### Android

The Flutter 3.47.2 fresh template currently uses AGP 9.1.0, Kotlin 2.4.0, Gradle 9.3.1, Java 17, and Flutter-owned
compile/min/target/NDK values. Prefer those template defaults unless a selected plugin proves incompatible.

Required changes:

- Target Android 16 / API 36 or newer. Current effective target is 34.
- Use Flutter's maintained minimum SDK. Flutter 3.47.2 supports Android API 24+.
- Use NDK r28+ and current AGP so 16 KB alignment is the default for rebuilt native libraries.
- Remove unconditional multidex and Jetifier/desugaring configuration when final dependencies do not require it.
- Use Flutter's pubspec version code/name instead of duplicating versions in `.env`.
- Verify a release AAB reports `PAGE_ALIGNMENT_16K`.
- Verify release APK native libraries with 16 KB zip/ELF alignment tooling.
- Test installation/launch on a 16 KB emulator or physical device.

### iOS

- Move to iOS 15, the Flutter 3.47.2 supported minimum.
- Accept and verify Flutter's UIScene migration.
- Enable the default Flutter SwiftPM integration.
- Build after the final plugin set is selected.
- Remove Podfile, Pods xcconfig includes, workspace references, Pods, and symlinks only after Flutter confirms no
  plugin falls back to CocoaPods.
- Verify simulator and no-sign device builds after CocoaPods removal.

## Package Plan

Versions below were current and resolvable during this audit.

| Treatment | Package | Version | Reason |
| --- | --- | --- | --- |
| Replace | `http` -> `dio` | 5.11.1 | Singleton config, interceptors, typed errors, timeouts, cancellation, progress |
| Replace | `flutter_smart_dialog` -> `toastification` | 3.2.0 | Dedicated feedback package; app wrapper can deduplicate and theme messages |
| Replace | `iconsax` -> `hugeicons` | 1.1.7 | Modern consistent rounded-stroke family; MIT; theme-aware; tree-shaken SVGs |
| Upgrade | `connectivity_plus` | 7.3.1 | Current network-interface signals |
| Add | `internet_connection_checker_plus` | 3.1.2 | Reachability signal for app-wide offline UI |
| Upgrade | `cached_network_image` | 4.0.0 | Current major; requires wrapper compatibility review |
| Upgrade | `intl` | 0.20.3 | Current compatible stable |
| Upgrade | `shared_preferences` | 2.5.5 | Non-sensitive preferences only |
| Upgrade | `shimmer` | 4.0.0 | Current major; review API changes |
| Upgrade | `flutter_launcher_icons` | 0.14.4 | Current compatible stable |

`get`, `flutter_screenutil`, `url_launcher`, `flutter_lints`, and the Flutter SDK dependency were already at their
current direct constraints during the audit.

### Icon decision

Recommend Hugeicons to match the improved SOANI foundation and the requested visual direction. Standardize on the
stroke-rounded family and one app stroke-width scale. Keep package references behind a small semantic `AppIcons`
mapping so a future icon-family change does not touch every screen.

Trade-off: Hugeicons adds `flutter_svg` and currently scores 140/160 on pub.dev because of repository metadata and a
documentation lint. Lucide is a leaner no-dependency alternative. Material Symbols is the better fallback when
Material 3/RTL fidelity matters more than a distinctive visual identity.

## Common Widget Organization

The current flat `core/widgets/` folder is already large enough to group by responsibility:

```text
core/widgets/
├── buttons/
│   ├── primary_button.dart
│   └── primary_outline_button.dart
├── feedback/
│   ├── app_toast.dart
│   ├── confirmation_dialog.dart
│   └── confirmation_sheet.dart
├── forms/
│   └── app_text_field.dart
├── media/
│   └── app_image.dart
├── navigation/
│   └── app_back_button.dart
├── state/
│   ├── empty_state_widget.dart
│   ├── error_state_widget.dart
│   ├── loading_widget.dart
│   └── skeletons.dart
├── connectivity/
│   ├── connectivity_banner.dart
│   └── connectivity_overlay.dart
└── layout/
    └── primary_safe_area.dart
```

Keep one public core-widget barrel. Feature-specific widgets stay under each feature's
`presentation/widgets/` folders and gain subfolders only when one concern has multiple related widgets.

## Additional Baseline Gaps

### Must add now

- Working unit tests for API mapping, feedback policy, error parsing, session expiry, cancellation, and toast
  deduplication.
- Working initialized app-shell widget test. Delete the counter test.
- Accessibility tests for contrast, target size, labels, and large text.
- CI quality gate: format check, analyze with fatal warnings/infos, tests, Android debug/release build, and iOS
  simulator build on dependency/native changes.
- App-level error boundary/reporting interface using `FlutterError.onError` and `PlatformDispatcher.instance.onError`.
- Production-safe structured logger with debug-only sanitized HTTP metadata.
- One app-wide connectivity banner and scoped reconnect coordinator. No global refresh-all request burst.
- Remove the 1.2 text-scale clamp. Test large text instead of silently overriding accessibility settings.
- Resolve portrait-only behavior vs iOS-declared landscape orientations.
- Fix the light theme using the dark card color at `lib/core/theme/light_theme.dart:29`.
- Remove deprecated-lint suppression and the removed lint from `analysis_options.yaml`.
- Replace direct navigation calls outside `AppNav`.
- Remove dead/commented notification code until notifications become an approved capability.

### Add when a real project needs it

- Firebase/Crashlytics/Sentry, analytics, App Check, push notifications, and remote config.
- Drift/offline cache and local drafts. Cache only approved reads; never add a generic offline mutation queue.
- Multiple native flavors/schemes. A validated compile-time environment is enough for the smallest template;
  development/staging/production flavors become useful when one project truly ships parallel variants.
- Deep links, universal/app links, background tasks, biometric gates, and runtime permission orchestration.
- Golden tests, screenshot testing, performance budgets, and app-size regression budgets.

These are not universal dependencies. The starter should expose clean extension points without forcing unused native
SDKs, permissions, privacy obligations, or binary weight into every app.

## Required Verification Gates

1. `dart format --page-width 110` on changed Dart files.
2. `flutter analyze` with zero issues.
3. `flutter test` with API/feedback/session/widget/accessibility coverage.
4. Android debug build.
5. Android signed release APK and AAB.
6. 16 KB zip/ELF alignment verification.
7. iOS simulator build through SwiftPM only.
8. iOS no-sign device build.
9. `flutter pub outdated` shows no avoidable direct dependency lag.
10. Search confirms no SmartDialog, Iconsax, tracked signing secrets, token/body logging, stale TODO, or direct
    navigation violation remains in active code.

## Implementation Order

1. Contain secrets and replace `.env`.
2. Upgrade/pin Flutter, Dart, dependencies, Android, iOS, UIScene, and SwiftPM.
3. Replace the API client, typed failures, session storage, feedback policy, connectivity, and tests.
4. Replace SmartDialog/Iconsax; add Toastification/Hugeicons.
5. Reorganize core widgets and fix accessibility/theme/navigation issues.
6. Add CI and run full native/release/16 KB verification.
7. Update `.agent/skills/flutter/` rules, examples, registry, decisions, and migration tracking last.

## Sources

- Flutter stable archive: https://docs.flutter.dev/install/archive
- Flutter supported platforms: https://docs.flutter.dev/reference/supported-platforms
- Flutter SwiftPM migration: https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers
- Flutter UIScene migration: https://docs.flutter.dev/release/breaking-changes/uiscenedelegate
- Google Play target API requirements: https://support.google.com/googleplay/android-developer/answer/11926878
- Android 16 KB page support: https://developer.android.com/guide/practices/page-sizes
- Dio: https://pub.dev/packages/dio
- Connectivity Plus limitation: https://pub.dev/packages/connectivity_plus
- HTTP retry/idempotency semantics: https://www.rfc-editor.org/rfc/rfc9110.html#name-idempotent-methods
- Flutter testing overview: https://docs.flutter.dev/testing/overview
- Flutter error handling: https://docs.flutter.dev/testing/errors
- Flutter accessibility testing: https://docs.flutter.dev/ui/accessibility/accessibility-testing
- Flutter CI/CD: https://docs.flutter.dev/deployment/cd
- Toastification: https://pub.dev/packages/toastification
- Hugeicons: https://pub.dev/packages/hugeicons
