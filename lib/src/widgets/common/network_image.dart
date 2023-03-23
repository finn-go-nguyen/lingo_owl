import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../themes/colors.dart';

class LNetworkImage extends StatelessWidget {
  const LNetworkImage(
    this.url, {
    super.key,
    this.fit = BoxFit.contain,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.dimension,
  });

  final String url;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final double? dimension;

  @override
  Widget build(BuildContext context) {
    final loading = Container(
      height: double.infinity,
      width: double.infinity,
      color: LColors.loading,
    ).animate().shimmer();
    const error = FlutterLogo();
    return SizedBox.square(
      dimension: dimension,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: kIsWeb
            ? Image.network(
                url,
                fit: fit,
                loadingBuilder: (_, __, ___) => loading,
                errorBuilder: (_, __, ___) => error,
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: fit,
                progressIndicatorBuilder: (_, __, ___) => loading,
                errorWidget: (_, __, ___) => error,
              ),
      ),
    );
  }
}
