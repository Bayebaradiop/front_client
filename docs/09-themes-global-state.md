# 9. Thèmes et État Global

## ThemeController

Regardez `lib/app/theme/theme_controller.dart` :

```dart
class ThemeController extends GetxController {
  // Stockage persistant
  final _storage = GetStorage();
  final _storageKey = 'isDarkMode';

  // État du thème
  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  // Thème actuel
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    // Chargement depuis le stockage
    _isDarkMode.value = _storage.read(_storageKey) ?? false;
  }

  // Basculement de thème
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.write(_storageKey, _isDarkMode.value);

    // Mise à jour du status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: _isDarkMode.value
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }
}
```

## Utilisation dans main.dart

```dart
void main() async {
  // Initialisation du controller de thème
  final themeCtrl = Get.put(ThemeController());

  runApp(GetMaterialApp(
    // Thèmes dynamiques
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: themeCtrl.themeMode,
    // ...
  ));
}
```

## AuthController Global

Regardez `lib/app/features/auth/controllers/auth_controller.dart` :

```dart
class AuthController extends GetxController {
  // Utilisateur connecté (accessible partout)
  final Rx<AuthModel?> currentUser = Rx<AuthModel?>(null);

  // État d'authentification
  final RxBool isAuthenticated = false.obs;

  // Méthodes d'authentification
  Future<void> login(String email, String password) async {
    try {
      final user = await repository.login(email, password);
      currentUser.value = user;
      isAuthenticated.value = true;

      // Navigation après connexion
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Erreur', 'Connexion échouée');
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.welcome);
  }
}
```

## Accès Global

Partout dans l'app :

```dart
// Accès au thème
final themeCtrl = Get.find<ThemeController>();
final isDark = themeCtrl.isDarkMode;

// Accès à l'utilisateur
final authCtrl = Get.find<AuthController>();
final user = authCtrl.currentUser.value;

// Basculement thème
themeCtrl.toggleTheme();
```

## Avantages

- **Persistance** : Thème sauvegardé automatiquement
- **Global** : Accessible partout sans prop drilling
- **Réactif** : UI se met à jour automatiquement
- **Centralisé** : Logique d'auth centralisée
