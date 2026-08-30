import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/auth_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    controller.loadProfile();

    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: AppBar(
        title: Text(
          Tr.editProfile.tr,
          style: DSTypography.headingSmall.copyWith(
            color: DSColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: DSColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: DSColors.textPrimary,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: DSColors.primaryDark,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Center(
                    child: Obx(() {
                      final user = controller.currentUser.value;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          controller.pickAndUploadPhoto();
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.6),
                                  width: 2,
                                ),
                              ),
                              child: UserAvatar(
                                photoUrl: user?.photo,
                                initials:
                                    '${(user?.prenom ?? '').isNotEmpty ? user!.prenom![0].toUpperCase() : ''}'
                                    '${(user?.nom ?? '').isNotEmpty ? user!.nom![0].toUpperCase() : ''}',
                                radius: 46,
                                fontSize: 28,
                                backgroundColor: Colors.white24,
                                textColor: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: DSColors.primaryDark,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Iconsax.camera, size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  Obx(() {
                    final user = controller.currentUser.value;
                    final fullName = '${user?.prenom ?? ''} ${user?.nom ?? ''}'.trim();
                    final role = (user?.role ?? 'PATIENT').toUpperCase();

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              fullName.isEmpty ? 'Mon Profil MediBook' : fullName,
                              style: DSTypography.headingMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: Color(0xFF38BDF8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: DSTypography.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Iconsax.shield_tick, size: 14, color: Color(0xFF10B981)),
                              const SizedBox(width: 6),
                              Text(
                                '$role VÉRIFIÉ',
                                style: DSTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informations Personnelles (Form Inputs)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DSColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: DSColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations Personnelles',
                    style: DSTypography.labelLarge.copyWith(
                      color: DSColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Prénom Input
                  Text(
                    Tr.firstName.tr,
                    style: DSTypography.labelMedium.copyWith(color: DSColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller.prenomProfileCtrl,
                    style: DSTypography.bodyMedium.copyWith(color: DSColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: Tr.firstName.tr,
                      prefixIcon: const Icon(Iconsax.user, color: DSColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nom Input
                  Text(
                    Tr.lastName.tr,
                    style: DSTypography.labelMedium.copyWith(color: DSColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller.nomProfileCtrl,
                    style: DSTypography.bodyMedium.copyWith(color: DSColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: Tr.lastName.tr,
                      prefixIcon: const Icon(Iconsax.user, color: DSColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Input
                  Text(
                    Tr.phoneNumber.tr,
                    style: DSTypography.labelMedium.copyWith(color: DSColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller.telephoneProfileCtrl,
                    keyboardType: TextInputType.phone,
                    style: DSTypography.bodyMedium.copyWith(color: DSColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: Tr.phoneNumber.tr,
                      prefixIcon: const Icon(Iconsax.call, color: DSColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Save Button
            Obx(
              () => CustomButton(
                text: Tr.save.tr,
                isLoading: controller.isLoading.value,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  controller.saveProfile();
                },
                icon: Iconsax.tick_circle,
              ),
            ),

            const SizedBox(height: 16),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  controller.logout();
                },
                icon: const Icon(Iconsax.logout, color: Color(0xFFEF4444), size: 18),
                label: Text(
                  Tr.logout.tr,
                  style: DSTypography.labelMedium.copyWith(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
