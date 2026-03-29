import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../core/utils/error_utils.dart';
import '../../../models/auth_model.dart';
import '../../../theme/app_colors.dart';
import '../../../translate/translation_keys.dart';
import '../viewmodel/auth_viewmodel.dart';

class AuthController extends GetxController with SnackbarMixin {
  final AuthViewModel _viewModel;

  AuthController(this._viewModel);

  // Champs de formulaire login
  final emailController = ''.obs;
  final passwordController = ''.obs;

  // Champs de formulaire register
  final prenomRegister = ''.obs;
  final nomRegister = ''.obs;
  final emailRegister = ''.obs;
  final telephoneRegister = ''.obs;
  final passwordRegister = ''.obs;
  final confirmPasswordRegister = ''.obs;

  // Raccourcis vers le viewmodel
  RxBool get isLoading => _viewModel.isLoading;
  RxBool get isLoggedIn => _viewModel.isLoggedIn;
  Rxn<AuthModel> get currentUser => _viewModel.currentUser;


  void login() async {
    // Validation champ par champ
    final emailError = ErrorUtils.validateEmail(emailController.value);
    if (emailError != null) {
      showError(emailError);
      return;
    }

    final passwordError = ErrorUtils.validatePassword(passwordController.value);
    if (passwordError != null) {
      showError(passwordError);
      return;
    }

    final error = await _viewModel.login(
      emailController.value,
      passwordController.value,
    );

    if (error == null) {
      Get.offAllNamed('/home');
      final user = _viewModel.currentUser.value;
      showSuccess(Tr.welcome.tr, '${user?.prenom} ${user?.nom}');
    } else {
      showError(error);
    }
  }
  

  void registerUser() async {
    // Validation champ par champ avec messages précis
    if (prenomRegister.value.trim().isEmpty) {
      showError(Tr.firstNameRequired.tr);
      return;
    }
    if (nomRegister.value.trim().isEmpty) {
      showError(Tr.lastNameRequired.tr);
      return;
    }

    final emailError = ErrorUtils.validateEmail(emailRegister.value);
    if (emailError != null) {
      showError(emailError);
      return;
    }

    final phoneError = ErrorUtils.validatePhone(telephoneRegister.value);
    if (phoneError != null) {
      showError(phoneError);
      return;
    }

    final passwordError = ErrorUtils.validatePassword(passwordRegister.value);
    if (passwordError != null) {
      showError(passwordError);
      return;
    }

    if (passwordRegister.value != confirmPasswordRegister.value) {
      showError(Tr.passwordMismatch.tr);
      return;
    }

    final error = await _viewModel.register(
      prenom: prenomRegister.value.trim(),
      nom: nomRegister.value.trim(),
      email: emailRegister.value.trim(),
      telephone: telephoneRegister.value.trim(),
      motDePasse: passwordRegister.value,
    );

    if (error == null) {
      Get.offAllNamed('/login');
      showSuccess(Tr.registerSuccess.tr, Tr.loginSuccess.tr);
    } else {
      showError(error);
    }
  }

  void logout() async {
    await _viewModel.logout();
    Get.offAllNamed('/login');
  }

  // Champs de formulaire profil
  final prenomProfileCtrl = TextEditingController();
  final nomProfileCtrl = TextEditingController();
  final telephoneProfileCtrl = TextEditingController();

  void loadProfile() async {
    // Pré-remplir depuis les données déjà en cache
    _syncProfileFields();
    // Puis rafraîchir depuis l'API
    final error = await _viewModel.fetchProfile();
    if (error != null) {
      if (_viewModel.currentUser.value == null) showError(error);
      return;
    }
    _syncProfileFields();
  }

  void _syncProfileFields() {
    final user = _viewModel.currentUser.value;
    if (user != null) {
      prenomProfileCtrl.text = user.prenom ?? '';
      nomProfileCtrl.text = user.nom ?? '';
      telephoneProfileCtrl.text = user.telephone ?? '';
    }
  }

  void saveProfile() async {
    final prenom = prenomProfileCtrl.text.trim();
    final nom = nomProfileCtrl.text.trim();
    final telephone = telephoneProfileCtrl.text.trim();

    debugPrint('[saveProfile] prenom="$prenom" nom="$nom" tel="$telephone"');
    if (prenom.isEmpty) {
      showError(Tr.firstNameRequired.tr);
      return;
    }
    if (nom.isEmpty) {
      showError(Tr.lastNameRequired.tr);
      return;
    }
    if (telephone.isNotEmpty) {
      final phoneError = ErrorUtils.validatePhone(telephone);
      if (phoneError != null) {
        showError(phoneError);
        return;
      }
    }

    final error = await _viewModel.updateProfile(
      prenom: prenom,
      nom: nom,
      telephone: telephone,
    );

    debugPrint('[saveProfile] result error=$error');
    if (error == null) {
      Get.back();
      showSuccess(Tr.success.tr, Tr.profileUpdated.tr);
    } else {
      showError(error);
    }
  }

  @override
  void onClose() {
    prenomProfileCtrl.dispose();
    nomProfileCtrl.dispose();
    telephoneProfileCtrl.dispose();
    super.onClose();
  }

  // ── Upload photo de profil ────────────────────────────────────────────
  void pickAndUploadPhoto() {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Iconsax.camera, color: AppColors.primary),
              title: Text(Tr.camera.tr),
              onTap: () {
                Get.back();
                _uploadFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery, color: AppColors.primary),
              title: Text(Tr.gallery.tr),
              onTap: () {
                Get.back();
                _uploadFromSource(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<void> _uploadFromSource(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 800, imageQuality: 85);
    if (picked == null) return;

    final file = File(picked.path);
    final error = await _viewModel.uploadProfilePhoto(file);
    if (error == null) {
      showSuccess(Tr.success.tr, Tr.photoUploadSuccess.tr);
    } else {
      showError(error);
    }
  }

  // ── Mot de passe oublié ──────────────────────────────────────────────
  final forgotEmail = ''.obs;
  final resetCode = ''.obs;
  final newPassword = ''.obs;
  final confirmNewPassword = ''.obs;
  final resetStep = 0.obs; // 0 = email, 1 = code + new password

  void sendResetCode() async {
    final emailError = ErrorUtils.validateEmail(forgotEmail.value);
    if (emailError != null) {
      showError(emailError);
      return;
    }

    final error = await _viewModel.forgotPassword(forgotEmail.value.trim());
    if (error == null) {
      resetStep.value = 1;
      showSuccess(Tr.success.tr, Tr.resetCodeSent.tr);
    } else {
      showError(error);
    }
  }

  void confirmResetPassword() async {
    if (resetCode.value.trim().length != 6) {
      showError(Tr.resetCodeInvalid.tr);
      return;
    }

    final passwordError = ErrorUtils.validatePassword(newPassword.value);
    if (passwordError != null) {
      showError(passwordError);
      return;
    }

    if (newPassword.value != confirmNewPassword.value) {
      showError(Tr.passwordMismatch.tr);
      return;
    }

    final error = await _viewModel.resetPassword(
      forgotEmail.value.trim(),
      resetCode.value.trim(),
      newPassword.value,
    );

    if (error == null) {
      // Reset state
      forgotEmail.value = '';
      resetCode.value = '';
      newPassword.value = '';
      confirmNewPassword.value = '';
      resetStep.value = 0;
      Get.offAllNamed('/login');
      showSuccess(Tr.success.tr, Tr.passwordResetSuccess.tr);
    } else {
      showError(error);
    }
  }

}
