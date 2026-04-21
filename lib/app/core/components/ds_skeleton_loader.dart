import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/design_system/colors_ds.dart';
import '../../theme/design_system/spacing_ds.dart';
import '../../theme/design_system/border_radius_ds.dart';

/// Shimmer skeleton loader for displaying during data loading
class DSSkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const DSSkeletonLoader({
    Key? key,
    this.width = double.infinity,
    this.height = 16,
    BorderRadius? borderRadius,
  })  : borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(8)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode
        ? DSColors.darkSurface.withOpacity(0.6)
        : DSColors.surfaceLight;
    final highlightColor = isDarkMode
        ? DSColors.darkSurface.withOpacity(0.8)
        : DSColors.surfaceLight.withOpacity(0.8);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: DSColors.textSecondary.withOpacity(0.2),
        ),
      ),
    );
  }
}

/// Skeleton card (typically for list items)
class DSSkeletonCard extends StatelessWidget {
  final double? width;
  final double height;

  const DSSkeletonCard({
    Key? key,
    this.width,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode
        ? DSColors.darkSurface.withOpacity(0.5)
        : Colors.white;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(DSSpacing.cardPadding),
      decoration: BoxDecoration(
        borderRadius: DSBorderRadius.mediumRadius,
        color: bgColor,
        border: Border.all(
          color: isDarkMode
              ? DSColors.darkBorder.withOpacity(0.3)
              : DSColors.borderLight.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Title line
          DSSkeletonLoader(
            width: double.infinity,
            height: 18,
            borderRadius: DSBorderRadius.smallRadius,
          ),
          SizedBox(height: DSSpacing.md),
          // Subtitle lines
          DSSkeletonLoader(
            width: double.infinity,
            height: 14,
            borderRadius: DSBorderRadius.smallRadius,
          ),
          SizedBox(height: DSSpacing.sm),
          DSSkeletonLoader(
            width: 150,
            height: 14,
            borderRadius: DSBorderRadius.smallRadius,
          ),
        ],
      ),
    );
  }
}

/// Full-screen skeleton (for complex layouts)
class DSSkeletonFullScreen extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const DSSkeletonFullScreen({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(DSSpacing.screenMargin),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: DSSpacing.itemSpacing),
        child: DSSkeletonCard(height: itemHeight),
      ),
    );
  }
}

/// Circular skeleton (for avatars, images)
class DSSkeletonCircle extends StatelessWidget {
  final double size;

  const DSSkeletonCircle({
    Key? key,
    this.size = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DSSkeletonLoader(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}
