import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String initials;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  const UserAvatar({
    super.key,
    this.photoUrl,
    required this.initials,
    this.radius = 24,
    this.backgroundColor = const Color(0x1A2E7D32), // primary 10%
    this.textColor = AppColors.primary,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
      onBackgroundImageError: hasPhoto
          ? (_, __) {} // silently fallback to initials
          : null,
      child: hasPhoto
          ? null
          : Text(
              initials,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
    );
  }
}
