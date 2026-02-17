import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Theme-aware shimmer wrapper. Wrap any widget to show a loading shimmer.
class CustomShimmer extends StatelessWidget {
  final Widget child;
  const CustomShimmer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.05),
      child: child,
    );
  }
}

/// Rectangular skeleton placeholder with configurable size.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({this.width, this.height = 100, this.borderRadius, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        width: width,
        height: height.sp,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.sp),
        ),
      ),
    );
  }
}

/// Circular skeleton placeholder (for avatars).
class SkeletonCircle extends StatelessWidget {
  final double size;
  const SkeletonCircle({this.size = 48, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        width: size.sp,
        height: size.sp,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
    );
  }
}

/// Full-width line skeleton (for text lines).
class SkeletonLine extends StatelessWidget {
  final double height;
  final double? width;

  const SkeletonLine({this.height = 14, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        width: width ?? double.infinity,
        height: height.sp,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.sp)),
      ),
    );
  }
}

/// Common list tile skeleton: leading circle + 2 lines.
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        children: [
          const SkeletonCircle(size: 48),
          SizedBox(width: 12.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(height: 14),
                SizedBox(height: 8.sp),
                SkeletonLine(height: 12, width: 150.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
