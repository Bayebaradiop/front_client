import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../models/auth_model.dart';
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
    if (emailController.value.isEmpty || passwordController.value.isEmpty) {
      showError(Tr.fillAllFields.tr);
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
    if (prenomRegister.value.isEmpty ||
        nomRegister.value.isEmpty ||
        emailRegister.value.isEmpty ||
        telephoneRegister.value.isEmpty ||
        passwordRegister.value.isEmpty ||
        confirmPasswordRegister.value.isEmpty) {
      showError(Tr.fillAllFields.tr);
      return;
    }

    if (passwordRegister.value != confirmPasswordRegister.value) {
      showError(Tr.passwordMismatch.tr);
      return;
    }

    final error = await _viewModel.register(
      prenom: prenomRegister.value,
      nom: nomRegister.value,
      email: emailRegister.value,
      telephone: telephoneRegister.value,
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
    if (prenom.isEmpty || nom.isEmpty) {
      showError(Tr.fillAllFields.tr);
      return;
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

}
