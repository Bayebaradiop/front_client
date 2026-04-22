import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? AppColors.textWhite,
        ),
      ),
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textWhite,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
