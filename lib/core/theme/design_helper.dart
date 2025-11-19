import '../../imports.dart';

class DesignHelper {
  static Size getDesignSize(BuildContext context) {
    const double shortestSide = 600; // Tablet threshold
    const double largeTabletThreshold = 800;

    final bool isTablet = MediaQuery.of(context).size.shortestSide > shortestSide;
    final bool isLargeTablet = MediaQuery.of(context).size.shortestSide > largeTabletThreshold;

    if (isLargeTablet) {
      return const Size(1024, 1366); // Large tablets
    } else if (isTablet) {
      return const Size(768, 1024); // Regular tablets
    } else {
      return const Size(411.4, 866.3); // Phones
    }
  }

  static double screenSize(num size, bool isTablet, bool isLargeTablet, ScreenUtil util) {
    double scaleFactor = 1.0;
    if (isTablet || isLargeTablet) {
      scaleFactor = 1.0;
    } else {
      scaleFactor = util.scaleText;
    }
    return size * scaleFactor;
  }
}
