import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/auth_controller.dart';
import '../../../translate/translation_keys.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    // Reset state on enter
    controller.resetStep.value = 0;
    controller.forgotEmail.value = '';
    controller.resetCode.value = '';
    controller.newPassword.value = '';
    controller.confirmNewPassword.value = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => controller.resetStep.value == 0
              ? _StepEmail(controller: controller)
              : _StepReset(controller: controller)),
        ),
      ),
    );
  }
}

// ─── STEP 1 : Enter email ──────────────────────────────────────────────
class _StepEmail extends StatelessWidget {
  final AuthController controller;
  const _StepEmail({required this.controller});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.lock_1, size: 56, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text(Tr.forgotPasswordTitle.tr, style: AppTextStyles.heading1),
        const SizedBox(height: 12),
        Text(
          Tr.forgotPasswordDesc.tr,
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => controller.forgotEmail.value = v,
          decoration: InputDecoration(
            hintText: Tr.email.tr,
            prefixIcon: const Icon(Iconsax.sms, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 24),
        Obx(() => CustomButton(
              text: Tr.sendCode.tr,
              isLoading: controller.isLoading.value,
              onPressed: controller.sendResetCode,
              icon: Iconsax.send_1,
            )),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            Tr.backToLogin.tr,
            style: AppTextStyles.body.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

// ─── STEP 2 : Code + New password ──────────────────────────────────────
class _StepReset extends StatelessWidget {
  final AuthController controller;
  const _StepReset({required this.controller});

  @override
  Widget build(BuildContext context) {
    final codeCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();
    final confirmPwdCtrl = TextEditingController();
    final obscureNew = true.obs;
    final obscureConfirm = true.obs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Iconsax.shield_tick, size: 56, color: AppColors.success),
        ),
        const SizedBox(height: 24),
        Text(Tr.resetPassword.tr, style: AppTextStyles.heading1),
        const SizedBox(height: 12),
        Obx(() => Text(
              '${Tr.resetCodeSent.tr}\n${controller.forgotEmail.value}',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 32),
        // Code field
        TextField(
          controller: codeCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (v) => controller.resetCode.value = v,
          decoration: InputDecoration(
            hintText: Tr.resetCodeHint.tr,
            prefixIcon:
                const Icon(Iconsax.key_square, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        // New password
        Obx(() => TextField(
              controller: newPwdCtrl,
              obscureText: obscureNew.value,
              onChanged: (v) => controller.newPassword.value = v,
              decoration: InputDecoration(
                hintText: Tr.newPassword.tr,
                prefixIcon:
                    const Icon(Iconsax.lock, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureNew.value ? Iconsax.eye_slash : Iconsax.eye,
                    color: AppColors.textLight,
                  ),
                  onPressed: () => obscureNew.value = !obscureNew.value,
                ),
              ),
            )),
        const SizedBox(height: 16),
        // Confirm new password
        Obx(() => TextField(
              controller: confirmPwdCtrl,
              obscureText: obscureConfirm.value,
              onChanged: (v) => controller.confirmNewPassword.value = v,
              decoration: InputDecoration(
                hintText: Tr.confirmNewPassword.tr,
                prefixIcon:
                    const Icon(Iconsax.lock, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirm.value ? Iconsax.eye_slash : Iconsax.eye,
                    color: AppColors.textLight,
                  ),
                  onPressed: () =>
                      obscureConfirm.value = !obscureConfirm.value,
                ),
              ),
            )),
        const SizedBox(height: 24),
        Obx(() => CustomButton(
              text: Tr.resetPassword.tr,
              isLoading: controller.isLoading.value,
              onPressed: controller.confirmResetPassword,
              icon: Iconsax.tick_circle,
            )),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => controller.resetStep.value = 0,
          child: Text(
            Tr.sendCode.tr,
            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
