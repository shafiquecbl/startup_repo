import 'package:startup_repo/imports.dart';
import 'package:toastification/toastification.dart';

import 'core/theme/design_helper.dart';
import 'core/services/connectivity/connectivity_service.dart';
import 'features/home/presentation/view/home.dart';
import 'features/theme/presentation/controller/theme_controller.dart';
import 'features/language/presentation/controller/localization_controller.dart';
import 'core/helper/get_di.dart' as di;
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/utils/messages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Map<String, Map<String, String>> languages = await di.init();
  final ConnectivityService connectivityService = Get.find<ConnectivityService>();
  runApp(MyApp(languages: languages, connectivityService: connectivityService));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final ConnectivityService connectivityService;

  const MyApp({required this.languages, required this.connectivityService, super.key});

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
          builder: (context, child) => GetBuilder<ThemeController>(
            builder: (themeController) {
              return ToastificationWrapper(
                child: GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  themeMode: themeController.themeMode,
                  theme: light,
                  darkTheme: dark,
                  locale: localizeController.locale,
                  translations: Messages(languages: languages),
                  fallbackLocale: const Locale('en', 'US'),
                  builder: (BuildContext context, Widget? child) => ConnectivityBanner(
                    connectivityService: connectivityService,
                    child: child ?? const SizedBox.shrink(),
                  ),
                  home: const HomeScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
