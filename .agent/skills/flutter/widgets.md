# Widgets — Rules

> Read before building any widget or screen.

---

## Rule 0: No `setState` — Use `ValueNotifier`

```dart
// ❌ WRONG
setState(() => _currentPage = index);

// ✅ CORRECT
final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
// in build:
onPageChanged: (int index) => _currentPage.value = index,
ValueListenableBuilder<int>(
  valueListenable: _currentPage,
  builder: (BuildContext context, int page, _) => DotsIndicator(page: page),
)
// dispose: _currentPage.dispose();
```

**Reference:** `food_home/presentation/widgets/promo_banner_carousel.dart`

---

## Rule 1: Class-Based Widgets Only

```dart
// ❌ WRONG — function widget
Widget _buildHeader() => Container(padding: AppPadding.p16, child: Text('Hi'));

// ✅ CORRECT — class widget
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) =>
      Container(padding: AppPadding.p16, child: Text('Hi'));
}
```

---

## Rule 2: Theme-First — Use Built-in Widgets

```
Need a styled widget?
├─ Can ThemeData sub-theme do it? → Use built-in directly.
├─ Need loading state or 1-2 extra params? → Use our wrapper.
└─ Truly novel UI? → Create custom widget (rare).
```

```dart
// ❌ WRONG — manual styling at call site
TextFormField(decoration: InputDecoration(filled: true, fillColor: Colors.grey[100], ...))
ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C63FF), ...), ...)

// ✅ CORRECT — style in theme, use bare widget
TextFormField(hintText: 'enter_email'.tr)
PrimaryButton(text: 'login', isLoading: con.isLoading, onPressed: _submit)
```

---

## Our Wrappers

| Widget | Wraps | Extra value |
|--------|-------|------------|
| `PrimaryButton` | `ElevatedButton` | `isLoading`, `icon` |
| `PrimaryOutlineButton` | `OutlinedButton` | `isLoading`, `icon` |
| `CustomTextField` | `TextFormField` | Label, icon, focusNode |
| `AppImage` | `CachedNetworkImage` | Shimmer, error, asset fallback |
| `ConfirmationDialog` | `showDialog` | Static `.show()` |
| `ConfirmationSheet` | `showModalBottomSheet` | Static `.show()` |
| `AppDialog` | `SmartDialog` | `.showLoading()`, `.showToast()` |

---

## State Widgets

```dart
const LoadingWidget()                          // centered spinner
EmptyStateWidget(icon: Iconsax.box, title: 'no_items'.tr)
ErrorStateWidget(message: 'error'.tr, onRetry: () => controller.load())

// Skeletons
const SkeletonBox(height: 120)
const SkeletonLine(height: 14)
const SkeletonListTile()
```

For feature-level skeletons, keep dedicated files under:
`features/<feature>/presentation/shimmers/`.
Consolidate related shimmers into one file when they are tightly related (e.g., list + stats + details for same feature).

---

## AppImage

```dart
// ✅ Always use AppImage — never Image.network() directly
AppImage(url: user.avatar, width: 48.sp, height: 48.sp, borderRadius: AppRadius.r24)
AppImage(asset: Images.logo, width: 120.sp)
```

---

## Dialogs & Sheets — Static `.show()`

```dart
// ✅ CORRECT
ConfirmationDialog.show(title: 'delete_item'.tr, onAccept: () {});
AppDialog.showLoading();
AppDialog.dismiss();
AppDialog.showToast('success'.tr);

// ❌ WRONG — loose function
showDialog(context: context, builder: (_) => ...);
```

---

## Form Pattern

```dart
class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  // ... more fields

  @override
  void dispose() {
    _emailCtrl.dispose(); _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      AuthController.find.login(_emailCtrl.text);
    }
  }
}
```

Key: `textInputAction: TextInputAction.next`, `onSubmitted: (_) => nextFocus.requestFocus()`, validate on submit.
