# GetX dans le Projet MediBook

## Introduction à GetX

GetX est un framework Flutter léger et puissant qui fournit :

- **Gestion d'état réactive** : Observable variables qui se mettent à jour automatiquement
- **Gestion de routes** : Navigation simplifiée sans context
- **Gestion de dépendances** : Injection de dépendances automatique
- **Internationalisation** : Support multilingue
- **Thèmes** : Gestion des thèmes clairs/sombres

## Architecture GetX dans MediBook

### 1. Structure des Features
Chaque feature suit le pattern MVC avec GetX :
```
features/
├── auth/
│   ├── views/          # Widgets UI
│   ├── controllers/    # Logique métier
│   ├── repository/     # Appels API
│   ├── bindings/       # Injection dépendances
│   └── models/         # Données
```

### 2. Controllers (Gestion d'État)
Les controllers contiennent la logique métier et l'état :
```dart
class HomeController extends GetxController {
  // Variables observables
  final RxInt currentIndex = 0.obs;
  final RxList<MedecinModel> medecins = <MedecinModel>[].obs;
  final RxBool isLoading = true.obs;

  // Méthodes pour modifier l'état
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
```

### 3. Views (Interface Utilisateur)
Les vues utilisent `Obx` pour réagir aux changements :
```dart
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() => IndexedStack(
      index: controller.currentIndex.value,
      children: [...],
    ));
  }
}
```

### 4. Bindings (Injection de Dépendances)
Les bindings créent et injectent les dépendances :
```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeRepository>(() => HomeRepository());
  }
}
```

### 5. Routes et Navigation
Navigation simplifiée sans context :
```dart
// Navigation
Get.toNamed(AppRoutes.doctors);

// Avec arguments
Get.toNamed(AppRoutes.doctorDetail, arguments: doctor);

// Retour
Get.back();
```

## Avantages dans ce Projet

1. **Performance** : Mise à jour automatique de l'UI
2. **Maintenabilité** : Séparation claire des responsabilités
3. **Productivité** : Moins de boilerplate code
4. **Testabilité** : Controllers faciles à tester
5. **Navigation** : Routing centralisé et typé

## Points Clés à Retenir

- `.obs` rend une variable observable
- `Obx()` wrap les widgets qui doivent se mettre à jour
- `Get.find<T>()` récupère une instance injectée
- `Get.toNamed()` pour la navigation
- Les controllers étendent `GetxController`
- Les bindings implémentent `Bindings`
