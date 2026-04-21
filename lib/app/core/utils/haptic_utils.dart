import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Haptic Feedback Utils - UX Mobile Enhancement
class HapticUtils {
  HapticUtils._();

  /// Light tap feedback - pour les selections, clicks
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  /// Medium tap feedback - pour les confirmations
  static void mediumTap() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy tap feedback - pour les actions importantes
  static void heavyTap() {
    HapticFeedback.heavyImpact();
  }

  /// Selection click - pour les sliders, pickers
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  /// Vibrate - pour les erreurs
  static void vibrate() {
    HapticFeedback.vibrate();
  }
}

/// Extension pour ajouter haptic aux widgets courants
extension HapticTap on Widget {
  Widget withHaptic(VoidCallback? onTap, {bool light = true}) {
    return GestureDetector(
      onTap: () {
        if (light) {
          HapticUtils.lightTap();
        } else {
          HapticUtils.mediumTap();
        }
        onTap?.call();
      },
      child: this,
    );
  }
}
