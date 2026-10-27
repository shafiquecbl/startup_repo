# Architectural Decisions

> Log every significant technical choice here. Format: date, decision, rationale.
> AI reads this before making architectural choices. Human reviews periodically.

<!-- Example:
## 2026-03-18 — Use FlutterSecureStorage for auth tokens
**Context:** Needed persistent secure storage for JWT tokens.
**Decision:** FlutterSecureStorage over SharedPreferences.
**Rationale:** SharedPreferences is plaintext. FSS uses Keychain (iOS) and EncryptedSharedPreferences (Android).
-->

## 2026-10-21 — Separate design tokens, theme roles, scaling, and adaptive layout

**Decision:** Keep numeric `fontXX`, `AppPadding`, `AppRadius`, and ScreenUtil where they improve clarity. Allow simple local geometry. Build runtime colors through `ThemeData`. Configure the Material 3 type scale in `ThemeData.textTheme`; AppText only exposes readable size aliases, with role suffixes where sizes collide. Use ScreenUtil for measurement scaling, `TextScaler` for accessibility, and constraints/breakpoints for structural adaptation.

**Rationale:** One abstraction should not hide every number or perform unrelated jobs. Clear boundaries preserve code readability, theme consistency, accessibility, and adaptive behavior.
