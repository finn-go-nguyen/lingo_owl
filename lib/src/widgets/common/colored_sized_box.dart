import 'package:flutter/material.dart';

class ColoredSizedBox extends StatelessWidget {
  const ColoredSizedBox({
    super.key,
    this.height,
    this.width,
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
  });

  final double? height;
  final double? width;
  final Color color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: color,
        child: SizedBox(
          height: height,
          width: width,
        ),
      ),
    );
  }
}