import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_system/colors_ds.dart';

/// Widget réutilisable pour afficher le logo d'un cabinet.
/// Affiche l'image réseau si disponible, sinon retourne à une icône stylisée.
class CabinetLogo extends StatelessWidget {
  final String? logoUrl;
  final double size;
  final double borderRadius;
  final Color accentColor;

  const CabinetLogo({
    super.key,
    this.logoUrl,
    this.size = 48,
    this.borderRadius = 14,
    this.accentColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoUrl != null && logoUrl!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: hasLogo ? Colors.white : accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: hasLogo ? DSColors.borderLight : accentColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: hasLogo
          ? Image.network(
              logoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _FallbackIcon(
                color: accentColor,
                size: size * 0.5,
              ),
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: SizedBox(
                    width: size * 0.35,
                    height: size * 0.35,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: accentColor.withValues(alpha: 0.5),
                    ),
                  ),
                );
              },
            )
          : _FallbackIcon(color: accentColor, size: size * 0.5),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  final Color color;
  final double size;
  const _FallbackIcon({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Iconsax.hospital, color: color, size: size),
    );
  }
}
