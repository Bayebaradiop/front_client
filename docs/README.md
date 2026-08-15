# 🧙‍♂️ Documentation Avancée GetX - MediBook

## 📚 Vue d'ensemble

Cette documentation détaille l'architecture GetX utilisée dans MediBook pour les développeurs qui connaissent déjà les bases.

## 🏗️ Architecture GetX dans MediBook

### Pattern MVVM Adapté

Chaque feature suit une architecture claire :
```
features/
├── nom-feature/
│   ├── controllers/    # Logique métier & état
│   ├── views/          # Interface utilisateur
│   ├── repository/     # Couche données
│   ├── bindings/       # Injection dépendances
│   └── models/         # Structures données
```

### Responsabilités

- **Controllers** : État, logique métier, appels repository
- **Views** : UI déclarative avec Obx()
- **Repository** : Abstraction données (API, cache, etc.)
- **Bindings** : Configuration injection dépendances
- **Models** : Sérialisation/désérialisation JSON

## 🔧 Concepts Avancés

### 1. Controllers & Cycle de Vie

```dart
class HomeController extends GetxController {
  // Injection dépendances
  final HomeRepository repository = Get.find();
  final AuthController authCtrl = Get.find();

  // État réactif
  final RxList<MedecinModel> medecins = <MedecinModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();  // Initialisation
  }

  @override
  void onReady() {
    super.onReady();
    // Widget prêt pour dialogs/snackbars
  }

  @override
  void onClose() {
    super.onClose();
    // Nettoyage ressources
  }

  // Workers pour réactions automatiques
  @override
  void onInit() {
    super.onInit();
    // Réagir aux changements avec debounce
    debounce(searchQuery, search, time: 500.ms);
    ever(currentUser, checkPermissions);
  }
}
```

### 2. Bindings & Injection

```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Injection lazy pour performance
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeRepository>(() => HomeRepository());

    // Injection globale si nécessaire
    Get.put<ApiService>(ApiService());
  }
}
```

### 3. Repository Pattern

```dart
class HomeRepository {
  final ApiService _api = Get.find();

  Future<List<MedecinModel>> getMedecins() async {
    try {
      final response = await _api.get('/medecins');
      return response.data.map((json) => MedecinModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur chargement médecins: $e');
    }
  }
}
```

### 4. Navigation Structurée

```dart
// Définition routes typées
class AppRoutes {
  static const home = '/home';
  static const medecins = '/medecins';
  static const medecinDetail = '/medecin-detail';
}

// Configuration avec bindings automatiques
final pages = [
  GetPage(
    name: AppRoutes.home,
    page: () => HomeView(),
    binding: HomeBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.medecins,
    page: () => MedecinsView(),
    binding: MedecinBinding(),
    transition: Transition.rightToLeft,
  ),
];

// Utilisation avec arguments typés
Get.toNamed(AppRoutes.medecinDetail, arguments: medecinModel);
```

### 5. Gestion d'État Global

```dart
class AuthController extends GetxController {
  final Rx<AuthModel?> currentUser = Rx<AuthModel?>(null);
  final RxBool isAuthenticated = false.obs;

  // Accessible partout dans l'app
  static AuthController get to => Get.find();

  Future<void> login(String email, String password) async {
    final user = await repository.login(email, password);
    currentUser.value = user;
    isAuthenticated.value = true;
    Get.offAllNamed(AppRoutes.home);
  }
}
```

## 🌍 Fonctionnalités Spécialisées

### Internationalisation
```dart
// Configuration multilingue
GetMaterialApp(
  translations: AppTranslations(),
  locale: const Locale('fr', 'FR'),
  fallbackLocale: const Locale('fr', 'FR'),
);

// Utilisation dans les vues
Text(Tr.home.tr);
Text(Tr.welcome.trParams({'name': user.name}));
```

### Thèmes Dynamiques
```dart
class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    GetStorage().write('isDarkMode', isDarkMode.value);
  }
}
```

## 🎯 Bonnes Pratiques

### 1. Séparation des Responsabilités
- Controllers : Logique métier uniquement
- Views : UI déclarative uniquement
- Repositories : Données uniquement

### 2. Performance
- Utiliser `Get.lazyPut()` pour les controllers
- Éviter les calculs lourds dans `build()`
- Utiliser `debounce` pour les recherches

### 3. Testabilité
```dart
void main() {
  // Injection de mocks pour tests
  Get.put<AuthRepository>(MockAuthRepository());
  Get.put<AuthController>(AuthController());

  test('Login success', () async {
    await Get.find<AuthController>().login('test@test.com', 'password');
    expect(Get.find<AuthController>().isAuthenticated.value, true);
  });
}
```

### 4. Gestion d'Erreurs
```dart
class HomeController extends GetxController {
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final data = await repository.getData();
      // Traitement succès
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

## 🔍 Debugging & Outils

### Logs GetX
```dart
// Activer les logs détaillés
Get.config(
  enableLog: true,
  logWriterCallback: (text, {isError = false}) {
    debugPrint(text);
  },
);
```

### Inspection État
```dart
// Voir tous les controllers injectés
print(Get.getAll());

// Voir si un controller existe
print(Get.isRegistered<HomeController>());
```

## 🚀 Extensions & Plugins

MediBook utilise plusieurs extensions GetX :
- **get_storage** : Persistance locale
- **get** : Framework principal
- **firebase_messaging** : Notifications
- **flutter_local_notifications** : Notifications locales

## 📚 Ressources Additionnelles

- [Documentation Officielle GetX](https://pub.dev/packages/get)
- [Architecture Flutter avec GetX](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)
- [Clean Architecture Flutter](https://pub.dev/packages/flutter_clean_architecture)

---

*Cette documentation suppose une connaissance préalable des bases GetX. Pour les débutants, consultez le [Guide pour Débutants](guide-principal-debutants.md).*</content>
<parameter name="filePath">docs/README-avance.md