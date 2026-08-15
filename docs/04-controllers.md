# 4. Controllers - Logique Métier

## Rôle du Controller

Le controller contient :
- L'état de la feature
- La logique métier
- Les appels aux repositories
- La gestion des erreurs

## Structure d'un Controller

Regardez `lib/app/features/home/controllers/home_controller.dart` :

```dart
class HomeController extends GetxController {
  // Repositories injectés
  final HomeRepository repository = Get.find<HomeRepository>();
  final AuthController authCtrl = Get.find<AuthController>();

  // État
  final RxList<MedecinModel> medecins = <MedecinModel>[].obs;
  final RxBool isLoading = true.obs;

  // Données calculées
  List<MedecinModel> get filteredMedecins => medecins.where(...).toList();

  @override
  void onInit() {
    super.onInit();
    loadData();  // Chargement initial
  }

  @override
  void onReady() {
    super.onReady();
    // Appelé quand le widget est prêt
  }

  @override
  void onClose() {
    super.onClose();
    // Nettoyage des ressources
  }

  // Actions utilisateur
  void changeTab(int index) {
    currentIndex.value = index;
  }

  // Chargement de données
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final result = await repository.getMedecins();
      medecins.assignAll(result);
    } catch (e) {
      // Gestion d'erreur
    } finally {
      isLoading.value = false;
    }
  }
}
```

## Cycle de Vie

1. `onInit()` : Initialisation, chargement des données
2. `onReady()` : Widget prêt, peut afficher des dialogs
3. `onClose()` : Nettoyage (timers, streams, etc.)

## Workers (Observateurs)

```dart
// Réagir aux changements
ever(currentIndex, (value) => print('Tab changé: $value'));

// Une seule fois
once(currentIndex, (value) => print('Premier changement'));

// Avec debounce
debounce(searchQuery, (value) => search(value), time: 500.ms);
```
