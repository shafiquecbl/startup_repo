import 'package:startup_repo/imports.dart';

class FoodDetailHeader extends StatelessWidget {
  final String imageUrl;

  const FoodDetailHeader({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero image
        AppImage(url: imageUrl, height: 280.sp, width: MediaQuery.of(context).size.width),

        // Gradient fade at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80.sp,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Theme.of(context).scaffoldBackgroundColor],
              ),
            ),
          ),
        ),

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.sp,
          left: 12.sp,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: AppPadding.p8,
              decoration: ShapeDecoration(color: Colors.black.withAlpha(100), shape: AppRadius.r16Shape),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }
}
