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

    if (!hasPhoto) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      );
    }

    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.network(
          photoUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              color: backgroundColor,
              child: Center(
                child: SizedBox(
                  width: radius * 0.6,
                  height: radius * 0.6,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: Text(
              initials.toUpperCase(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
