import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../../../translate/translation_keys.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final obscurePassword = true.obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Illustration
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(Tr.welcome.tr, style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                Tr.welcomeSubtitle.tr,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Email
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => controller.emailController.value = v,
                decoration: InputDecoration(
                  hintText: Tr.email.tr,
                  prefixIcon:
                      const Icon(Iconsax.sms, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              // Password
              Obx(() => TextField(
                    controller: passwordCtrl,
                    obscureText: obscurePassword.value,
                    onChanged: (v) =>
                        controller.passwordController.value = v,
                    decoration: InputDecoration(
                      hintText: Tr.password.tr,
                      prefixIcon: const Icon(Iconsax.lock,
                          color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                          color: AppColors.textLight,
                        ),
                        onPressed: () =>
                            obscurePassword.value = !obscurePassword.value,
                      ),
                    ),
                  )),
              const SizedBox(height: 32),
              // Login button
              Obx(() => CustomButton(
                    text: Tr.connect.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                    icon: Iconsax.login,
                  )),
              const SizedBox(height: 24),
              // Info test
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.info_circle,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        Tr.testAccount.tr,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Lien inscription
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Tr.noAccount.tr,
                    style: AppTextStyles.body,
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    child: Text(
                      Tr.createAccount.tr,
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.primary),
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
