import 'package:cached_network_image/cached_network_image.dart';
import 'package:startup_repo/imports.dart';

/// Unified image widget for network and asset images.
/// Handles loading (shimmer), error states, and caching for network images.
class AppImage extends StatelessWidget {
  final String? url;
  final String? asset;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AppImage({
    this.url,
    this.asset,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  }) : assert(url != null || asset != null, 'Provide either url or asset');

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (url != null) {
      image = CachedNetworkImage(
        imageUrl: url!,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, _) => CustomShimmer(child: Container(color: Colors.grey[300])),
        errorWidget: (_, _, _) => AppImageError(width: width!, height: height!),
      );
    } else {
      image = Image.asset(
        asset!,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) => AppImageError(width: width!, height: height!),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

class AppImageError extends StatelessWidget {
  final double width;
  final double height;
  const AppImageError({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Center(child: Icon(Iconsax.image, size: 50.sp)),
    );
  }
}
