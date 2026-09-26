# Widgets — Rules

> Read before building any widget or screen.

---

## Quick Rules

1. **No `setState()`** — local state uses `ValueNotifier`; shared/feature state uses `GetBuilder`.
2. **Class widgets only** — no `Widget _buildX()` helpers.
3. **Screens orchestrate only** — route setup, controller binding, and high-level layout stay in screen files.
4. **Meaningful widget classes get own files** — feature widgets live in `features/<feature>/presentation/widgets/`.
5. **Extract repeated visuals once** — repeated in one feature → feature widget; used by 2+ features → `core/widgets/`.
6. **Large widget sets get subfolders** — group by focus like `header/`, `form/`, `summary/`, `sheet/`.
7. **Do not over-fragment tiny layout** — keep a one-off `Row`/`Padding` inline until it earns a name.
8. **Theme-first UI** — prefer built-in themed widgets, then app wrappers, then custom widgets.
9. **Use app wrappers** — `PrimaryButton`, `CustomTextField`, `AppImage`, dialogs/sheets, state widgets.
10. **Use state widgets** — `LoadingWidget`, `EmptyStateWidget`, `ErrorStateWidget`, skeletons.
11. **Use `AppImage`** — no direct `Image.network()` in app UI.
12. **Dialogs/sheets expose static `.show()`** — no loose `showDialog()`/`showModalBottomSheet()` in views.
13. **Forms own controllers/focus nodes** — validate on submit and dispose everything.
14. **Feature widgets own their feature state** — do not explode one controller into long field/callback constructor lists.
15. **No `FutureBuilder` for feature data** — controller state renders loading/error/empty/content.

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

### Feature Widget Ownership

A screen composes sections. It should not read one controller, derive every label, and forward all state/actions as
parameters. That hides the real behavior in the screen and makes every child rebuild with a large constructor.

```dart
// ✅ Feature-specific section owns its focused reactive subtree.
class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (ProfileController controller) {
        return ProfileIdentityContent(profile: controller.profile, onEdit: controller.openEditProfile);
      },
    );
  }
}
```

- Feature-specific widgets may use their focused controller directly.
- Reusable presentational widgets receive one cohesive model/value plus semantic callbacks.
- Core widgets stay controller-agnostic and accept only the configuration they genuinely need.
- Do not pass controller-derived title, subtitle, status, photo, progress, and fixed navigation callbacks separately.
- Keep fixed navigation and feature actions with the feature widget/controller that owns them.
- Do not copy a visual component and tweak each screen independently.
- Parameterize meaningful variations, but do not replace copies with one giant dozens-of-parameters widget.

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
| `AppToast` | `Toastification` | Deduplicated success/error/info/warning feedback |

---

## State Widgets

```dart
const LoadingWidget()                          // centered spinner
EmptyStateWidget(icon: Icons.inbox_outlined, title: 'no_items'.tr)
ErrorStateWidget(message: 'error'.tr, onRetry: () => controller.load())

// Skeletons
const SkeletonBox(height: 120)
const SkeletonLine(height: 14)
const SkeletonListTile()
```

For feature-level skeletons, keep dedicated files under:
`features/<feature>/presentation/shimmers/`.
Consolidate related shimmers into one file when they are tightly related (e.g., list + stats + details for same feature).

Choose feedback by operation:

| Operation | UI treatment |
| --- | --- |
| First content load with known layout | Layout-matching skeleton with a subtle fade/pulse |
| Blocking startup/session work | Full-screen loader when the next layout is genuinely unknown |
| Pull-to-refresh | Keep content visible and show refresh feedback |
| Pagination | Footer loader/skeleton; never replace the current list |
| Button/tile mutation | Loading only on the affected control |

Avoid an aggressive sweeping highlight. A skeleton should preserve the expected layout and feel quieter than the
content it represents.

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
ConfirmationDialog.show(
  title: 'delete_item',
  subtitle: 'delete_item_confirmation',
  actionText: 'delete',
  onAccept: controller.deleteItem,
);
AppToast.success('saved_successfully'.tr);

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

Keyboard and focus rules:

- Intermediate single-line field: `TextInputAction.next`, then request the next focus node.
- Final form field: `TextInputAction.done`, then submit or unfocus.
- Chat/search action: use `send`/`search` when that is the actual action.
- Multiline field: use newline only when line breaks are meaningful; otherwise use done and dismiss/submit.
- `onSubmitted` must move focus, submit, or unfocus. Do not leave the keyboard action inert.
- Tap-outside dismissal supplements a correct keyboard action; it does not replace it.
- Dispose every owned `TextEditingController`, `FocusNode`, and notifier.
