import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:startup_repo/controller/theme_controller.dart';
import 'package:startup_repo/utils/colors.dart';

import 'package:startup_repo/utils/style.dart';
import 'package:startup_repo/view/base/common/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // demonstrate all the text theme,
            Text(
              'Display Large(${displayLarge(context).fontSize?.ceilToDouble()})',
              style: displayLarge(context),
            ),
            Text(
              'Display Medium(${displayMedium(context).fontSize?.ceilToDouble()})',
              style: displayMedium(context),
            ),
            Text(
              'Display Small(${displaySmall(context).fontSize?.ceilToDouble()})',
              style: displaySmall(context),
            ),
            Text(
              'Headline Large(${headlineLarge(context).fontSize?.ceilToDouble()})',
              style: headlineLarge(context),
            ),
            Text(
              'Headline Medium(${headlineMedium(context).fontSize?.ceilToDouble()})',
              style: headlineMedium(context),
            ),
            Text(
              'Headline Small(${headlineSmall(context).fontSize?.ceilToDouble()})',
              style: headlineSmall(context),
            ),
            Text(
              'Title Large(${titleLarge(context).fontSize?.ceilToDouble()})',
              style: titleLarge(context),
            ),
            Text(
              'Title Medium(${titleMedium(context).fontSize?.ceilToDouble()})',
              style: titleMedium(context),
            ),
            Text(
              'Title Small(${titleSmall(context).fontSize?.ceilToDouble()})',
              style: titleSmall(context),
            ),
            Text(
              'Body Large(${bodyLarge(context).fontSize?.ceilToDouble()})',
              style: bodyLarge(context),
            ),
            Text(
              'Body Medium(${bodyMedium(context).fontSize?.ceilToDouble()})',
              style: bodyMedium(context),
            ),
            Text(
              'Body Small(${bodySmall(context).fontSize?.ceilToDouble()})',
              style: bodySmall(context),
            ),
            Text(
              'Label Large(${labelLarge(context).fontSize?.ceilToDouble()})',
              style: labelLarge(context),
            ),
            Text(
              'Label Medium(${labelMedium(context).fontSize?.ceilToDouble()})',
              style: labelMedium(context),
            ),
            Text(
              'Label Small(${labelSmall(context).fontSize?.ceilToDouble()})',
              style: labelSmall(context),
            ),
            SizedBox(height: 32.sp),
            Row(
              children: [
                Expanded(
                  child: PrimaryOutlineButton(
                    text: 'Outline Button',
                    icon: Icon(Iconsax.video, size: 16, color: primaryColor),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: PrimaryButton(
                    text: 'Primary Button',
                    icon: const Icon(Iconsax.video, size: 16, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.sp),
            GetBuilder<ThemeController>(builder: (con) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ThemeModeWidget(
                    text: 'system',
                    themeMode: ThemeMode.system,
                    selected: con.themeMode == ThemeMode.system,
                  ),
                  ThemeModeWidget(
                    text: 'light',
                    themeMode: ThemeMode.light,
                    selected: con.themeMode == ThemeMode.light,
                  ),
                  ThemeModeWidget(
                    text: 'dark',
                    themeMode: ThemeMode.dark,
                    selected: con.themeMode == ThemeMode.dark,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ThemeModeWidget extends StatelessWidget {
  final String text;
  final ThemeMode themeMode;
  final bool selected;
  const ThemeModeWidget({required this.text, required this.themeMode, required this.selected, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ThemeController.find.setThemeMode(themeMode),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60.sp,
            height: 60.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? primaryColor : Theme.of(context).hintColor,
                width: 1.5.sp,
              ),
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: selected ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).hintColor,
            ),
          ),
          SizedBox(height: 8.sp),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  IconData get icon {
    switch (themeMode) {
      case ThemeMode.system:
        return Iconsax.monitor_mobbile;
      case ThemeMode.light:
        return Iconsax.sun_1;
      case ThemeMode.dark:
        return Iconsax.moon;
    }
  }
}
