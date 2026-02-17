import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:startup_repo/imports.dart';
import 'core/theme/design_helper.dart';
import 'features/food_home/presentation/view/food_home_screen.dart';
import 'features/theme/presentation/controller/theme_controller.dart';
import 'features/language/presentation/controller/localization_controller.dart';
import 'core/helper/get_di.dart' as di;
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/utils/messages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final Map<String, Map<String, String>> languages = await di.init();
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({required this.languages, super.key});

  @override
  Widget build(BuildContext context) {
    final Size designSize = DesignHelper.getDesignSize(context);
    final bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final bool isLargeTablet = MediaQuery.of(context).size.shortestSide > 800;
    return GetBuilder<LocalizationController>(
      builder: (localizeController) {
        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          fontSizeResolver: (num size, ScreenUtil util) {
            return DesignHelper.screenSize(size, isTablet, isLargeTablet, util);
          },
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2))),
            child: GetBuilder<ThemeController>(
              builder: (themeController) {
                return GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  themeMode: themeController.themeMode,
                  theme: light,
                  darkTheme: dark,
                  locale: localizeController.locale,
                  translations: Messages(languages: languages),
                  fallbackLocale: const Locale('en', 'US'),
                  navigatorObservers: [FlutterSmartDialog.observer],
                  builder: FlutterSmartDialog.init(loadingBuilder: (string) => const LoadingWidget()),
                  home: const FoodHomeScreen(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
