import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    this.shapeBorder,
    this.isLightColor = false,
    this.baseColorShade,
    this.highlightColor,
  });

  final double width;
  final double height;
  final ShapeBorder? shapeBorder;
  final bool? isLightColor;
  final int? baseColorShade;
  final int? highlightColor;

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.isLightColor = false,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.baseColorShade,
    this.highlightColor,
  });

  const ShimmerWidget.oval({
    super.key,
    required this.width,
    required this.height,
    this.isLightColor = false,
    this.shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
    this.baseColorShade,
    this.highlightColor,
  });

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.isLightColor = false,
    this.shapeBorder = const CircleBorder(),
    this.baseColorShade,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade400,
      child: Container(
        decoration: ShapeDecoration(shape: shapeBorder!, color: Colors.blue),
        width: width,
        height: height,
      ),
    );
  }
}
