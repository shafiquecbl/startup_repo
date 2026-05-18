# Widgets — Rules

> Read before building any widget or screen.

---

## Quick Rules

1. **No `setState()`** — local state uses `ValueNotifier`; shared/feature state uses `GetBuilder`.
2. **Class widgets only** — no `Widget _buildX()` helpers.
3. **Screens orchestrate only** — route setup, controller binding, and high-level layout stay in screen files.
4. **Meaningful widget classes get own files** — feature widgets live in `features/<feature>/presentation/widgets/`.
5. **Shared widgets move to `core/widgets/`** — only when used by 2+ features.
6. **Large widget sets get subfolders** — group by focus like `header/`, `form/`, `summary/`, `sheet/`.
7. **Do not over-fragment tiny layout** — keep a one-off `Row`/`Padding` inline until it earns a name.
8. **Theme-first UI** — prefer built-in themed widgets, then app wrappers, then custom widgets.
9. **Use app wrappers** — `PrimaryButton`, `CustomTextField`, `AppImage`, dialogs/sheets, state widgets.
10. **Use state widgets** — `LoadingWidget`, `EmptyStateWidget`, `ErrorStateWidget`, skeletons.
11. **Use `AppImage`** — no direct `Image.network()` in app UI.
12. **Dialogs/sheets expose static `.show()`** — no loose `showDialog()`/`showModalBottomSheet()` in views.
13. **Forms own controllers/focus nodes** — validate on submit and dispose everything.

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

## Rule 2: Widget Files Stay Separate

Screen files orchestrate routes, controller binding, and high-level layout only.

When you create a widget class:
- put it in its own file
- keep feature widgets under `features/<feature>/presentation/widgets/`
- move shared widgets used by 2+ features to `core/widgets/`
- if `widgets/` grows large, group by focus folder: `header/`, `form/`, `summary/`, `sheet/`

Do not keep multiple extracted widget classes at the bottom of one screen file.
Do not create micro-widgets for one `Row`/`Padding`; keep small layout inline until it earns a name.

```
presentation/
├── view/
│   └── checkout_screen.dart    # orchestration only
└── widgets/
    ├── checkout_header.dart
    ├── payment/
    │   ├── payment_method_tile.dart
    │   └── payment_summary_card.dart
    └── totals/
        └── order_total_row.dart
```

---

## Rule 3: Theme-First — Use Built-in Widgets

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
