# Design System

## Geometry
- Centralize repeated product decisions, not every number. Use AppPadding/AppRadius/context.fontXX where helpful; simple local gaps and approved one-off geometry may stay explicit.
- Short names: p16, r16, font16; no duplicate padding16/circular16/bodyText16.
- Use direct .sp gaps when clearer; unique EdgeInsets may stay direct. Exact approved values beat nearby tokens; no one-off token merely to avoid a literal. Add shared tokens only for repeated need.
- AppPadding: p4/p8/p16/p24/p32 → corresponding sp all-side padding.
- AppRadius: r4/r8/r16/r24/r100 → corresponding sp radii. r16 returns BorderRadius; r16Shape returns ShapeBorder. Superellipse only for the approved component shape.

## Colors and typography
- AppColors.primary/secondary and lightColors/darkColors build ThemeData. Runtime surfaces/text/dividers/component colors come from active theme/context: ColorScheme, component themes, dividerColor.
- Widgets never select lightColors/darkColors directly. Additional product colors use a typed ThemeExtension.
- TextTheme owns complete typography: size, weight, line height and letter spacing. AppText/context getters return the configured Material 3 slot unchanged; never construct/reshape typography or derive base styles there.
- Numeric aliases: font11/font12/font14/font16/font22/font24/font28/font32/font36/font45/font57. Same-size role aliases: font16Title, font14Title, font14Label, font12Label.
- copyWith only for an approved local variation; preserve remaining configured metrics.

## Responsive and platform UI
- ScreenUtil scales measurements from the approved design canvas. System TextScaler owns accessibility text scaling.
- LayoutBuilder constraints/breakpoints own structural changes; MediaQuery.sizeOf supports app-window decisions.
- Adapt navigation, columns, panes and maximum content width through constraints; retain safe minimum touch targets when visuals scale down.
- Configure system bars, edge-to-edge and global insets once at the app shell/native window; no repeated per-screen wrappers or padding.

## Assets and brand
- Project raster assets → WebP unless a platform requires another format. Lossless WebP for transparency/crisp UI edges.
- Keep generated drafts outside the project; save only approved final assets. After approval remove obsolete project variants and keep one canonical filename.
- Launcher, native splash, Flutter splash and primary actions resolve to one brand-color source.
- Give Android adaptive and Android 12 marks their own safe-zone canvases. Regenerate platform outputs; verify color and visible bounds instead of reusing one asset everywhere.
