# Widgets

## Extraction and ownership
- Keep readable, cohesive UI inline. Extract only for useful reuse, reduced complexity or clear ownership of independent state/resources.
- A name, callback, a few repeated lines or a shorter screen alone does not justify extraction.
- Each extracted widget class gets its own file; no extra extracted classes at the bottom of a screen. Exception: tightly related feature shimmers may share a file, as described under State presentation.
- Same-feature widgets → features/<feature>/presentation/widgets/; used by 2+ features → core/widgets/. Group large widget sets by focus, e.g. header/form/summary/sheet.
- Feature-specific widgets read controller-owned data through the owning controller/GetBuilder. Keep their UI action handlers, fixed navigation and local UI state inside the owning widget instead of passing controller-derived values and callbacks through the parent screen. Keep constructors const wherever possible.
- Reusable presentational widgets remain controller-agnostic and receive one cohesive model/value plus semantic callbacks. Core widgets remain controller-agnostic and take only necessary data/configuration and callbacks.
- No long constructor lists of controller-derived titles/state/actions. Reuse meaningful components; parameterize real variations without a giant dozens-of-parameters widget or copy-and-tweak screens.

## Theme-first components
- Prefer built-in UI primitives styled by ThemeData sub-themes. Use existing app wrappers for loading or extra behavior/configuration; new custom primitives only for genuinely novel UI (rare). Feature-widget extraction follows Extraction and ownership above.
- PrimaryButton → ElevatedButton + isLoading/icon; PrimaryOutlineButton → OutlinedButton + isLoading/icon.
- CustomTextField → TextFormField + label/icon/focusNode.
- AppImage → CachedNetworkImage + shimmer/error/asset fallback. Use it for app images; no direct Image.network().
- ConfirmationDialog/ConfirmationSheet expose static .show(); no loose showDialog()/showModalBottomSheet() in views.
- AppToast → deduplicated success/error/info/warning feedback through Toastification.

## State presentation
- Use LoadingWidget, EmptyStateWidget, ErrorStateWidget and SkeletonBox/SkeletonLine/SkeletonListTile.
- Feature shimmers → presentation/shimmers/. Tightly related shimmers may share one file.
- Known first-content layout → matching skeleton with subtle fade/pulse; quiet, no aggressive sweeping highlight.
- Blocking startup/session work with genuinely unknown next layout → full-screen loader allowed.
- Refresh → keep content + refresh feedback. Pagination → footer loader/skeleton, preserve list. Button/tile mutation → progress only on the affected control.
- Request lifecycle and failure/empty semantics → [Architecture](architecture.md).

## Forms
- Forms own their input controllers/focus nodes and validate on submit before calling the controller. All user-input validation follows [Architecture](architecture.md#inputs-models-mappings-and-endpoints). Dispose every owned TextEditingController, FocusNode and notifier.
- Intermediate single-line field → TextInputAction.next + request next focus.
- Final field → done + submit or unfocus. Actual chat/search action → send/search.
- Multiline → newline only when line breaks matter; otherwise done + dismiss/submit.
- onSubmitted must move focus, submit or unfocus. Tap-outside dismissal supplements keyboard behavior; it does not replace it.
