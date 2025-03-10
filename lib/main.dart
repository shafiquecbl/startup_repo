// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:startup_repo/core/widgets/loading.dart';
import 'features/language/presentation/controller/localization_controller.dart';
import 'features/theme/presentation/controller/theme_controller.dart';
import 'core/helper/get_di.dart' as di;
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/utils/app_constants.dart';
import 'core/utils/messages.dart';
import 'core/utils/scroll_behavior.dart';
import 'features/home/presentation/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // disable landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // initialize localization
  Map<String, Map<String, String>> languages = await di.init();

  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({required this.languages, super.key});

  @override
  Widget build(BuildContext context) {
    // Example criteria for device type detection
    final bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final bool isLargeTablet = MediaQuery.of(context).size.shortestSide > 800;
    // Define designSizes for different devices
    Size designSize;
    if (isLargeTablet) {
      designSize = const Size(1024, 1366); // Example for large tablets
    } else if (isTablet) {
      designSize = const Size(768, 1024); // Example for regular tablets
    } else {
      designSize = const Size(411.4, 866.3); // Example for phones
    }
    return GetBuilder<LocalizationController>(builder: (localizeController) {
      return GetBuilder<ThemeController>(
        builder: (themeController) {
          return ScreenUtilInit(
            designSize: designSize,
            minTextAdapt: true,
            splitScreenMode: true,
            fontSizeResolver: (size, util) => _screenSize(size, isTablet, isLargeTablet, util),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2),
                ),
              ),
              child: GetMaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                themeMode: themeController.themeMode,
                theme: light(context),
                darkTheme: dark(context),
                locale: localizeController.locale,
                translations: Messages(languages: languages),
                fallbackLocale: Locale(
                  AppConstants.languages.first.languageCode,
                  AppConstants.languages.first.countryCode,
                ),
                navigatorObservers: [FlutterSmartDialog.observer],
                builder: FlutterSmartDialog.init(
                  loadingBuilder: (string) => const LoadingWidget(),
                  builder: (context, child) {
                    return ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: child ?? const SizedBox(),
                    );
                  },
                ),
                home: const HomeScreen(),
              ),
            ),
          );
        },
      );
    });
  }

  double _screenSize(size, isTablet, isLargeTablet, util) {
    double scaleFactor = 1.0;
    if (isTablet || isLargeTablet) {
      scaleFactor = 1.0;
    } else {
      scaleFactor = util.scaleText;
    }
    return size * scaleFactor;
  }
}
