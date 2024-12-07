import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
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
            SizedBox(height: 16.sp),
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
          ],
        ),
      ),
    );
  }
}
