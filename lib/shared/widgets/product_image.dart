import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? url;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholderColor = scheme.surfaceContainerHighest;

    final image = (url == null || url!.isEmpty)
        ? Container(
            color: placeholderColor,
            alignment: Alignment.center,
            child: FaIcon(
              FontAwesomeIcons.image,
              size: 32,
              color: scheme.onSurfaceVariant,
            ),
          )
        : CachedNetworkImage(
            imageUrl: url!,
            fit: fit,
            placeholder: (_, _) => Shimmer.fromColors(
              baseColor: placeholderColor,
              highlightColor: scheme.surface,
              child: Container(color: placeholderColor),
            ),
            errorWidget: (_, _, _) => Container(
              color: placeholderColor,
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.fileImage,
                size: 28,
                color: scheme.onSurfaceVariant,
              ),
            ),
          );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
