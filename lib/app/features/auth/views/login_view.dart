import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailCtrl = TextEditingController(
      text: controller.emailController.value,
    );
    final passwordCtrl = TextEditingController(
      text: controller.passwordController.value,
    );
    final obscurePassword = true.obs;

    return Scaffold(
      backgroundColor: DSColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Medical Header Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: DSColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: DSColors.primaryLight.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: DSColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Portail Santé Sécurisé MediBook',
                      style: DSTypography.labelSmall.copyWith(
                        color: DSColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Animated Icon Emblem
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [DSColors.primaryDark, DSColors.primary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: DSColors.primary.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.user_square,
                  size: 48,
                  color: DSColors.white,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                Tr.connect.tr,
                style: DSTypography.headingLarge.copyWith(
                  color: DSColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Tr.welcomeSubtitle.tr,
                style: DSTypography.bodyMedium.copyWith(
                  color: DSColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Login Form Card Container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: DSColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => controller.emailController.value = value,
                      style: DSTypography.bodyLarge.copyWith(color: DSColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: Tr.email.tr,
                        prefixIcon: const Icon(Iconsax.sms, color: DSColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => TextField(
                        controller: passwordCtrl,
                        obscureText: obscurePassword.value,
                        onChanged: (value) =>
                            controller.passwordController.value = value,
                        onSubmitted: (_) => controller.login(),
                        style: DSTypography.bodyLarge.copyWith(color: DSColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: Tr.password.tr,
                          prefixIcon: const Icon(
                            Iconsax.lock,
                            color: DSColors.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                              color: DSColors.textLight,
                            ),
                            onPressed: () =>
                                obscurePassword.value = !obscurePassword.value,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                        child: Text(
                          Tr.forgotPassword.tr,
                          style: DSTypography.labelMedium.copyWith(
                            color: DSColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomButton(
                        text: Tr.connect.tr,
                        isLoading: controller.isLoading.value,
                        onPressed: controller.login,
                        icon: Iconsax.login,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  Text(
                    Tr.noAccount.tr,
                    style: DSTypography.bodyMedium.copyWith(
                      color: DSColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    ),
                    child: Text(
                      Tr.createAccount.tr,
                      style: DSTypography.labelLarge.copyWith(
                        color: DSColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
