# 5. Bindings - Injection de Dépendances

## Pourquoi des Bindings ?

Les bindings créent et injectent automatiquement les dépendances quand on navigue vers une page.

## Exemple dans HomeBinding

Regardez `lib/app/features/home/bindings/home_binding.dart` :

```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Injection lazy (créé seulement quand utilisé)
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeRepository>(() => HomeRepository());

    // Injection immédiate
    Get.put<ApiService>(ApiService());
  }
}
```

## Types d'Injection

### 1. Get.put() - Immédiate
```dart
Get.put<Controller>(Controller());  // Créé tout de suite
```

### 2. Get.lazyPut() - Lazy
```dart
Get.lazyPut<Controller>(() => Controller());  // Créé au premier accès
```

### 3. Get.find() - Récupération
```dart
final controller = Get.find<HomeController>();  // Récupère l'instance
```

## Dans les Routes

Regardez `lib/app/routes/app_pages.dart` :

```dart
GetPage(
  name: AppRoutes.home,
  page: () => const HomeView(),
  binding: HomeBinding(),  // Injection automatique
  transition: Transition.fadeIn,
),
```

Quand on navigue vers `/home`, le `HomeBinding` crée automatiquement le controller et repository !

## Avantages

- **Découplage** : Les vues ne connaissent pas la création des dépendances
- **Testabilité** : Facile de mocker les dépendances
- **Performance** : Lazy loading des controllers
- **Mémoire** : Nettoyage automatique quand on quitte la page
