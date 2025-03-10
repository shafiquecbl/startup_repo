import 'package:startup_repo/features/theme/presentation/controller/theme_controller.dart';
import 'package:startup_repo/core/widgets/confirmation_dialog.dart';
import 'package:startup_repo/core/widgets/confirmation_sheet.dart';
import '../../../../imports.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: paddingDefault,
        children: [
          Column(
            children: <Widget>[
              Text('w100', style: titleSmall(context).copyWith(fontWeight: FontWeight.w100)),
              Text('w200', style: titleSmall(context).copyWith(fontWeight: FontWeight.w200)),
              Text('w300', style: titleSmall(context).copyWith(fontWeight: FontWeight.w300)),
              Text('w400', style: titleSmall(context).copyWith(fontWeight: FontWeight.w400)),
              Text('w500', style: titleSmall(context).copyWith(fontWeight: FontWeight.w500)),
              Text('w600', style: titleSmall(context).copyWith(fontWeight: FontWeight.w600)),
              Text('w700', style: titleSmall(context).copyWith(fontWeight: FontWeight.w700)),
              Text('w800', style: titleSmall(context).copyWith(fontWeight: FontWeight.w800)),
              Text('w900', style: titleSmall(context).copyWith(fontWeight: FontWeight.w900)),
            ],
          ),
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
          SizedBox(height: spacingExtraLarge),
          Row(
            children: [
              Expanded(
                child: PrimaryOutlineButton(
                  text: 'Outline Button',
                  icon: Icon(Iconsax.video, size: 16.sp, color: primaryColor),
                  onPressed: () {
                    showConfirmationSheet(
                      title: 'Are you sure?',
                      subtitle: 'This action cannot be undone.',
                      actionText: 'Yes',
                      onAccept: pop,
                    );
                  },
                ),
              ),
              SizedBox(width: spacingDefault),
              Expanded(
                child: PrimaryButton(
                  text: 'Primary Button',
                  icon: Icon(Iconsax.video, size: 16.sp, color: Colors.white),
                  onPressed: () {
                    showConfirmationDialog(
                      title: 'Are you sure?',
                      subtitle: 'This action cannot be undone.',
                      actionText: 'Yes',
                      onAccept: pop,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: spacingExtraLarge),
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
          SizedBox(height: spacingExtraLarge),
          const CustomTextField(hintText: 'Enter text', prefixIcon: Iconsax.search_normal),
          SizedBox(height: spacingDefault),
          CustomDropDown(
            hintText: 'Dropdown',
            items: const [
              DropdownMenuItem(
                value: 'Item 1',
                child: Text('Item 1'),
              ),
              DropdownMenuItem(
                value: 'Item 2',
                child: Text('Item 2'),
              ),
              DropdownMenuItem(
                value: 'Item 3',
                child: Text('Item 3'),
              ),
            ],
            onChanged: (value) {},
          )
        ],
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
