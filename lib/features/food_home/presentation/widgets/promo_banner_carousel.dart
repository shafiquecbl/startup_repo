import 'dart:async';
import 'package:startup_repo/imports.dart';
import '../../data/model/promo_banner.dart';

class PromoBannerCarousel extends StatefulWidget {
  final List<PromoBanner> banners;

  const PromoBannerCarousel({super.key, required this.banners});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final int nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 160.sp,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final PromoBanner banner = widget.banners[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.sp),
                child: ClipRRect(
                  borderRadius: AppRadius.r16,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      AppImage(url: banner.image, fit: BoxFit.cover),

                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withAlpha(180)],
                          ),
                        ),
                      ),

                      // Text content
                      Positioned(
                        left: 16.sp,
                        bottom: 16.sp,
                        right: 16.sp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner.title,
                              style: context.font16.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (banner.subtitle != null) ...[
                              SizedBox(height: 4.sp),
                              Text(banner.subtitle!, style: context.font12.copyWith(color: Colors.white70)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Dots indicator
        SizedBox(height: 8.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 3.sp),
              height: 6.sp,
              width: _currentPage == index ? 20.sp : 6.sp,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppColors.primary : AppColors.primary.withAlpha(50),
                borderRadius: AppRadius.r100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
