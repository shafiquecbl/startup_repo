import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A quiet loading pulse that preserves the final content layout.
class CustomShimmer extends StatefulWidget {
  final Widget child;
  const CustomShimmer({required this.child, super.key});

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this)
      ..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.45,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Opacity(opacity: 0.65, child: widget.child);
    }
    return FadeTransition(opacity: _opacity, child: widget.child);
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
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4.sp),
        ),
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
