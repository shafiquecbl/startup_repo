import 'package:startup_repo/features/theme/presentation/controller/theme_controller.dart';

import '../../../../imports.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: AppPadding.p16,
        children: [
          Column(
            children: <Widget>[
              Text('w100', style: context.font18.copyWith(fontWeight: FontWeight.w100)),
              Text('w200', style: context.font18.copyWith(fontWeight: FontWeight.w200)),
              Text('w300', style: context.font18.copyWith(fontWeight: FontWeight.w300)),
              Text('w400', style: context.font18.copyWith(fontWeight: FontWeight.w400)),
              Text('w500', style: context.font18.copyWith(fontWeight: FontWeight.w500)),
              Text('w600', style: context.font18.copyWith(fontWeight: FontWeight.w600)),
              Text('w700', style: context.font18.copyWith(fontWeight: FontWeight.w700)),
              Text('w800', style: context.font18.copyWith(fontWeight: FontWeight.w800)),
              Text('w900', style: context.font18.copyWith(fontWeight: FontWeight.w900)),
            ],
          ),
          SizedBox(height: 32.sp),
          Row(
            children: [
              Expanded(
                child: PrimaryOutlineButton(
                  text: 'Outline Button',
                  icon: AppIcon(
                    icon: HugeIcons.strokeRoundedVideo01,
                    size: 16.sp,
                    color: context.theme.primaryColor,
                  ),
                  onPressed: () {
                    ConfirmationSheet.show(
                      title: 'Are you sure?',
                      subtitle: 'This action cannot be undone.',
                      actionText: 'Yes',
                      onAccept: AppNav.back,
                    );
                  },
                ),
              ),
              SizedBox(width: 16.sp),
              Expanded(
                child: PrimaryButton(
                  text: 'Primary Button',
                  icon: AppIcon(icon: HugeIcons.strokeRoundedVideo01, size: 16.sp, color: Colors.white),
                  onPressed: () {
                    ConfirmationDialog.show(
                      title: 'Are you sure?',
                      subtitle: 'This action cannot be undone.',
                      actionText: 'Yes',
                      onAccept: AppNav.back,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 32.sp),
          GetBuilder<ThemeController>(
            builder: (con) {
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
            },
          ),
          SizedBox(height: 32.sp),
          const CustomTextField(hintText: 'Enter text', prefixIcon: HugeIcons.strokeRoundedSearch01),
          SizedBox(height: 16.sp),
          CustomDropDown<String>(
            hintText: 'Dropdown',
            items: const [
              DropdownMenuItem(value: 'Item 1', child: Text('Item 1')),
              DropdownMenuItem(value: 'Item 2', child: Text('Item 2')),
              DropdownMenuItem(value: 'Item 3', child: Text('Item 3')),
            ],
            onChanged: (String? value) {},
          ),
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
                color: selected ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                width: 1.5.sp,
              ),
            ),
            child: AppIcon(icon: icon, size: 18.sp),
          ),
          SizedBox(height: 8.sp),
          Text(text, style: context.font12),
        ],
      ),
    );
  }

  AppIconData get icon {
    switch (themeMode) {
      case ThemeMode.system:
        return HugeIcons.strokeRoundedComputer;
      case ThemeMode.light:
        return HugeIcons.strokeRoundedSun01;
      case ThemeMode.dark:
        return HugeIcons.strokeRoundedMoon02;
    }
  }
}
