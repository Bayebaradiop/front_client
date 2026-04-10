import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailCtrl = TextEditingController(text: controller.emailController.value);
    final passwordCtrl = TextEditingController(text: controller.passwordController.value);
    final obscurePassword = true.obs;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.login,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(Tr.connect.tr, style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                Tr.welcomeSubtitle.tr,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.emailController.value = value,
                decoration: InputDecoration(
                  hintText: Tr.email.tr,
                  prefixIcon: const Icon(Iconsax.sms, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),
              Obx(
                () => TextField(
                  controller: passwordCtrl,
                  obscureText: obscurePassword.value,
                  onChanged: (value) => controller.passwordController.value = value,
                  onSubmitted: (_) => controller.login(),
                  decoration: InputDecoration(
                    hintText: Tr.password.tr,
                    prefixIcon: const Icon(Iconsax.lock, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.textLight,
                      ),
                      onPressed: () => obscurePassword.value = !obscurePassword.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                  child: Text(
                    Tr.forgotPassword.tr,
                    style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomButton(
                  text: Tr.connect.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                  icon: Iconsax.login,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  Tr.testAccount.tr,
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Tr.noAccount.tr, style: AppTextStyles.body),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    child: Text(
                      Tr.createAccount.tr,
                      style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}