# Widgets — Theme-First, Class-Based, Lean

> **When to read:** Before creating ANY new widget, styling a UI component,
> or building a screen.

---

## ⚠️ Rule 0: No `setState` — Use `ValueNotifier`

**NEVER use `setState()` in any widget.** For local UI state (page index, toggle,
animation), use `ValueNotifier` + `ValueListenableBuilder`. For shared state, use
`GetBuilder<Controller>`.

```dart
// ❌ WRONG — setState causes full rebuild of entire widget
class _MyWidgetState extends State<MyWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (int index) => setState(() => _currentPage = index),
      // ...
    );
  }
}

// ✅ CORRECT — ValueNotifier rebuilds only the listening subtree
class _MyWidgetState extends State<MyWidget> {
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageView(
          onPageChanged: (int index) => _currentPage.value = index,
          // ...
        ),
        ValueListenableBuilder<int>(
          valueListenable: _currentPage,
          builder: (BuildContext context, int page, _) {
            return DotsIndicator(currentPage: page);
          },
        ),
      ],
    );
  }
}
```

**Why:** `setState` rebuilds the entire `build()` method. `ValueNotifier` rebuilds
only the `ValueListenableBuilder` subtree — better performance and more explicit.

**Reference:** `food_home/presentation/widgets/promo_banner_carousel.dart`

---

## ⚠️ Rule 1: Class-Based Only — No Exceptions

**NEVER use function/method-based widgets.** Every reusable piece of UI MUST be a
`StatelessWidget` or `StatefulWidget` class. This is non-negotiable.

```dart
// ❌ WRONG — Function widget (anti-pattern)
Widget _buildHeader() {
  return Container(
    padding: AppPadding.p16,
    child: Text('Header', style: context.font16),
  );
}

// ✅ CORRECT — Class-based widget
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.p16,
      child: Text('Header', style: context.font16),
    );
  }
}
```

**Why:** Flutter diffs by widget type (classes get smart diffing, functions don't),
`const` prevents rebuilds, classes show in DevTools.

---

## ⚠️ Rule 2: Theme-First — Use Built-in Widgets

**Decision tree before creating any widget:**

```
Need a styled widget?
├─ Can ThemeData sub-theme achieve the design?
│   └─ YES → Use the built-in widget directly. DONE.
├─ Need the built-in + 1-2 fixed convenience params (e.g. loading)?
│   └─ YES → Create a thin wrapper (like PrimaryButton).
└─ Truly novel UI that no built-in covers?
    └─ YES → Create a custom widget (RARE).
```

**Built-in widgets you must NEVER recreate — theme them instead:**

| Built-in Widget | Theme Key | Common Anti-Pattern |
|-----------------|-----------|---------------------|
| `ElevatedButton` | `ElevatedButtonThemeData` | Custom button with hardcoded colors |
| `OutlinedButton` | `OutlinedButtonThemeData` | Custom outline button with borders |
| `TextButton` | `TextButtonThemeData` | Custom text-only button |
| `IconButton` | `IconButtonThemeData` | Custom icon tap target |
| `TextFormField` | `InputDecorationTheme` | Styling borders/colors per-instance |
| `showDialog` | `DialogTheme` | Building custom dialog containers |
| `showModalBottomSheet` | `BottomSheetThemeData` | Building custom sheet widgets |
| `AppBar` | `AppBarTheme` | Custom header widgets |
| `Card` | `CardTheme` | Custom container with shadows |
| `ListTile` | `ListTileThemeData` | Custom row layouts |
| `Divider` | `DividerThemeData` | `Container(height: 1, color: ...)` |
| `DropdownMenu` | `DropdownMenuThemeData` | Custom dropdown widgets |
| `Icon` | `IconThemeData` | Setting size/color per-instance |
| `Chip` | `ChipThemeData` | Custom tag/badge widgets |
| `TabBar` | `TabBarTheme` | Custom tab implementations |
| `NavigationBar` | `NavigationBarThemeData` | Custom bottom navs |
| `SnackBar` | `SnackBarThemeData` | Custom toast containers |
| `Switch` | `SwitchThemeData` | Custom toggle widgets |
| `Checkbox` | `CheckboxThemeData` | Custom checkmark widgets |
| `Radio` | `RadioThemeData` | Custom radio buttons |
| `FloatingActionButton` | `FloatingActionButtonThemeData` | Custom FABs |
| `Slider` | `SliderThemeData` | Custom range selectors |
| `ProgressIndicator` | `ProgressIndicatorThemeData` | Custom loaders |

---

## Concrete Examples — Anti-Pattern vs. Correct

### TextFormField (the #1 offender)

```dart
// ❌ WRONG — Manually styling at every usage site
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    hintStyle: TextStyle(color: Colors.grey),
  ),
)

// ✅ CORRECT — Define InputDecorationTheme ONCE in theme, use bare widget
// In core/theme/src/input_decoration_theme.dart:
InputDecorationTheme inputDecorationTheme(AppColors colors) => InputDecorationTheme(
  filled: true,
  fillColor: colors.card,
  border: OutlineInputBorder(borderRadius: AppRadius.r16, borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(borderRadius: AppRadius.r16, borderSide: BorderSide(color: colors.primary)),
  contentPadding: AppPadding.p16,
);

// Then anywhere in the app — just use it clean:
TextFormField(hintText: 'enter_email'.tr)
// or use our convenience wrapper when you need a label:
CustomTextField(labelText: 'email', hintText: 'enter_email')
```

### ElevatedButton

```dart
// ❌ WRONG — Hardcoding style at call site
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF6C63FF),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    padding: EdgeInsets.symmetric(vertical: 14),
  ),
  onPressed: () {},
  child: Text('Submit'),
)

// ✅ CORRECT — Theme handles everything, call site is clean
// In core/theme/src/elevated_button_theme.dart:
ElevatedButtonThemeData elevatedButtonTheme(AppColors colors) => ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: colors.primary,
    foregroundColor: Colors.white,
    shape: AppRadius.r16Shape,
    padding: AppPadding.p16,
  ),
);

// Then in any screen — zero styling:
ElevatedButton(onPressed: () {}, child: Text('Submit'.tr))
// or use our wrapper for loading/icon:
PrimaryButton(text: 'Submit', isLoading: controller.isLoading, onPressed: () {})
```

### Card

```dart
// ❌ WRONG — Custom Container with manual shadow
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
  ),
  child: content,
)

// ✅ CORRECT — Use Card widget with CardTheme
// In core/theme/src/card_theme.dart (if needed):
CardThemeData cardTheme(AppColors colors) => CardThemeData(
  color: colors.card,
  shape: AppRadius.r16Shape,
  elevation: 0,
);

// Then:
Card(child: Padding(padding: AppPadding.p16, child: content))
```

### Switch / Checkbox / Radio

```dart
// ❌ WRONG — Styling per instance
Switch(
  value: isEnabled,
  onChanged: onChanged,
  activeColor: Color(0xFF6C63FF),
  activeTrackColor: Color(0xFF6C63FF).withOpacity(0.3),
  inactiveThumbColor: Colors.grey,
  inactiveTrackColor: Colors.grey[300],
)

// ✅ CORRECT — Theme it once, use bare widget everywhere
// In theme:
SwitchThemeData switchTheme(AppColors colors) => SwitchThemeData(
  thumbColor: WidgetStatePropertyAll(colors.primary),
  trackColor: WidgetStateProperty.resolveWith((states) =>
    states.contains(WidgetState.selected) ? colors.primary.withOpacity(0.3) : colors.divider,
  ),
);

// Then:
Switch(value: isEnabled, onChanged: onChanged)
```

### Divider

```dart
// ❌ WRONG — Manual separator
Container(height: 1, color: Colors.grey[300], margin: EdgeInsets.symmetric(vertical: 8))

// ✅ CORRECT — Built-in Divider with DividerTheme
const Divider()
```

> **Key takeaway:** If you find yourself writing `style:`, `decoration:`, or
> `color:` directly on a built-in widget, STOP. That styling belongs in the
> ThemeData sub-theme, not at the call site. The ONLY exception is a genuine
> one-off override (rare).

---

## Rule 3: Static `.show()` for Dialogs/Sheets

All dialogs, sheets, and overlays use a **static method on the class**:

```dart
// ❌ WRONG — loose function
showConfirmationDialog(title: '...', onAccept: () {});

// ✅ CORRECT — static method (discoverable: type ClassName. → IDE shows all)
ConfirmationDialog.show(title: '...', onAccept: () {});
ConfirmationSheet.show(title: '...', onAccept: () {});
AppDialog.showLoading();
AppDialog.showToast('OK');
```

---

## Our Wrapper Widgets (convenience only)

| Widget | Wraps | Added Value |
|--------|-------|-------------|
| `PrimaryButton` | `ElevatedButton` | `isLoading`, `icon` convenience |
| `PrimaryOutlineButton` | `OutlinedButton` | `isLoading`, `icon` convenience |
| `CustomTextField` | `TextFormField` | Label above field, icon wiring |
| `ConfirmationDialog` | `showDialog` | Static `.show()`, pre-built layout |
| `ConfirmationSheet` | `showModalBottomSheet` | Static `.show()`, pre-built layout |
| `AppDialog` | `SmartDialog` | Unified loading/toast API |
| `AppImage` | `CachedNetworkImage` / `Image.asset` | Unified network+asset, shimmer, error |
| `CustomTextField` | `TextFormField` | Label, icon wiring, focusNode |

---

## State Widgets (use these everywhere)

```dart
// Loading — centered spinner
const LoadingWidget()

// Empty state — icon + title + optional subtitle + optional action
EmptyStateWidget(
  icon: Iconsax.box,
  title: 'no_items',
  subtitle: 'no_items_subtitle',
  actionText: 'add_item',
  onAction: () {},
)

// Error state — message + optional retry
ErrorStateWidget(
  message: 'something_went_wrong',
  onRetry: () => controller.loadData(),
)
```

---

## Skeleton Loading (use for shimmer placeholders)

```dart
const SkeletonBox(height: 120)              // rectangular skeleton
const SkeletonCircle(size: 48)              // circular (avatars)
const SkeletonLine(height: 14)              // text line
const SkeletonLine(height: 12, width: 150)  // shorter text line
const SkeletonListTile()                    // leading circle + 2 lines
```

---

## Image Handling

Use `AppImage` for all images — handles network (shimmer + error + caching)
and asset images through a single widget:

```dart
// Network image with border radius
AppImage(url: user.avatar, width: 48.sp, height: 48.sp, borderRadius: AppRadius.r24)

// Asset image
AppImage(asset: Images.logo, width: 120.sp)

// Card image
AppImage(url: post.imageUrl, height: 200.sp, borderRadius: AppRadius.r16)

// Basic network (fills parent)
AppImage(url: imageUrl)
```

**Rules:**
- **Never** use `Image.network()` directly — no loading/error states
- **Always** provide `width`/`height` or constrain with parent
- Use `borderRadius` param instead of wrapping in `ClipRRect`

---

## Form Validation Pattern

Validate on submit + use **FocusNodes** for field switching:

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailCtrl,
            focusNode: _emailFocus,
            labelText: 'email',
            hintText: 'enter_email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _passFocus.requestFocus(),
            validator: (v) => v == null || v.isEmpty ? 'email_required'.tr : null,
          ),
          CustomTextField(
            controller: _passCtrl,
            focusNode: _passFocus,
            labelText: 'password',
            hintText: 'enter_password',
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            validator: (v) => v != null && v.length < 6 ? 'password_min_6'.tr : null,
          ),
          SizedBox(height: 24.sp),
          GetBuilder<AuthController>(builder: (con) {
            return PrimaryButton(
              text: 'login',
              isLoading: con.isLoading,
              onPressed: _submit,
            );
          }),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      AuthController.find.login(_emailCtrl.text, _passCtrl.text);
    }
  }
}
```

**Rules:**
- Validate on submit, not on every keystroke
- Use `FocusNode` + `onSubmitted` + `requestFocus()` for field switching
- Use `TextInputAction.next` on intermediate fields, `.done` on last field
- Dispose all controllers and focus nodes in `dispose()`
- Use `.tr` for all validation messages
- Use `isLoading` on the submit button
