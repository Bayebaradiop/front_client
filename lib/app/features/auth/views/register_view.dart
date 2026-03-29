import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../../../translate/translation_keys.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final prenomCtrl = TextEditingController();
    final nomCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final telephoneCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    final obscurePassword = true.obs;
    final obscureConfirm = true.obs;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Illustration
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.user_add,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(Tr.createAccount.tr, style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                Tr.welcomeSubtitle.tr,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Prénom
              TextField(
                controller: prenomCtrl,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => controller.prenomRegister.value = v,
                decoration: InputDecoration(
                  hintText: Tr.firstName.tr,
                  prefixIcon:
                      const Icon(Iconsax.user, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Nom
              TextField(
                controller: nomCtrl,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => controller.nomRegister.value = v,
                decoration: InputDecoration(
                  hintText: Tr.lastName.tr,
                  prefixIcon: const Icon(Iconsax.user_tag,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Email
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => controller.emailRegister.value = v,
                decoration: InputDecoration(
                  hintText: Tr.email.tr,
                  prefixIcon:
                      const Icon(Iconsax.sms, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Téléphone
              TextField(
                controller: telephoneCtrl,
                keyboardType: TextInputType.phone,
                onChanged: (v) => controller.telephoneRegister.value = v,
                decoration: InputDecoration(
                  hintText: Tr.phoneNumber.tr,
                  prefixIcon:
                      const Icon(Iconsax.call, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Mot de passe
              Obx(() => TextField(
                    controller: passwordCtrl,
                    obscureText: obscurePassword.value,
                    onChanged: (v) =>
                        controller.passwordRegister.value = v,
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
              const SizedBox(height: 14),

              // Confirmer mot de passe
              Obx(() => TextField(
                    controller: confirmPasswordCtrl,
                    obscureText: obscureConfirm.value,
                    onChanged: (v) =>
                        controller.confirmPasswordRegister.value = v,
                    decoration: InputDecoration(
                      hintText: Tr.confirmPassword.tr,
                      prefixIcon: const Icon(Iconsax.lock_1,
                          color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirm.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                          color: AppColors.textLight,
                        ),
                        onPressed: () =>
                            obscureConfirm.value = !obscureConfirm.value,
                      ),
                    ),
                  )),
              const SizedBox(height: 28),

              // Bouton inscription
              Obx(() => CustomButton(
                    text: Tr.createAccount.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.registerUser,
                    icon: Iconsax.user_add,
                  )),
              const SizedBox(height: 20),

              // Lien vers connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Tr.alreadyHaveAccount.tr,
                    style: AppTextStyles.body,
                  ),
                  TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.login),
                    child: Text(
                      Tr.connect.tr,
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.primary),
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
