import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../translate/translation_keys.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/user_avatar.dart';
import '../controllers/auth_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    controller.loadProfile();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Tr.editProfile.tr, style: AppTextStyles.heading3),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Obx(() {
                final user = controller.currentUser.value;
                return UserAvatar(
                  photoUrl: user?.photo,
                  initials: '${(user?.prenom ?? '').isNotEmpty ? user!.prenom![0].toUpperCase() : ''}'
                      '${(user?.nom ?? '').isNotEmpty ? user!.nom![0].toUpperCase() : ''}',
                  radius: 50,
                  fontSize: 32,
                );
              }),
            ),
            const SizedBox(height: 8),
            Center(
              child: Obx(() {
                final user = controller.currentUser.value;
                return Text(
                  user?.email ?? '',
                  style: AppTextStyles.body.copyWith(color: AppColors.textLight),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Prénom
            Text(Tr.firstName.tr, style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            TextField(
              controller: controller.prenomProfileCtrl,
              decoration: InputDecoration(
                hintText: Tr.firstName.tr,
                prefixIcon: const Icon(Iconsax.user, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // Nom
            Text(Tr.lastName.tr, style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            TextField(
              controller: controller.nomProfileCtrl,
              decoration: InputDecoration(
                hintText: Tr.lastName.tr,
                prefixIcon: const Icon(Iconsax.user, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // Téléphone
            Text(Tr.phoneNumber.tr, style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            TextField(
              controller: controller.telephoneProfileCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: Tr.phoneNumber.tr,
                prefixIcon: const Icon(Iconsax.call, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            Obx(() => CustomButton(
                  text: Tr.save.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.saveProfile,
                  icon: Iconsax.tick_circle,
                )),
          ],
        ),
      ),
    );
  }
}
