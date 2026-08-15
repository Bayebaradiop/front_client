# 6. Navigation avec GetX

## Navigation sans Context

GetX permet de naviguer sans avoir besoin du `BuildContext` !

## Exemples dans MediBook

### Navigation Simple

```dart
// Vers une route nommée
Get.toNamed(AppRoutes.doctors);

// Avec arguments
Get.toNamed(AppRoutes.doctorDetail, arguments: doctorData);

// Retour
Get.back();

// Retour à la racine
Get.offAllNamed(AppRoutes.login);
```

### Navigation dans les Cards

Regardez dans `home_view.dart` :

```dart
// Navigation vers détail cabinet
onTap: () => Get.toNamed(AppRoutes.cabinetDetail, arguments: cabinet)

// Navigation vers médecins d'une spécialité
onTap: () => Get.toNamed(AppRoutes.medecins, arguments: {'specialiteId': spec.id})
```

## Arguments

### Passage d'Arguments

```dart
// Objet complet
Get.toNamed(AppRoutes.doctorDetail, arguments: doctorModel);

// Objet Map
Get.toNamed(AppRoutes.doctors, arguments: {'specialiteId': 1, 'ville': 'Paris'});
```

### Récupération d'Arguments

Dans le controller ou la vue :

```dart
// Récupération dans controller
final args = Get.arguments;
if (args is Map) {
  final specialiteId = args['specialiteId'];
}

// Récupération dans vue
final doctor = Get.arguments as MedecinModel;
```

## Transitions

GetX fournit des transitions prédéfinies :

```dart
GetPage(
  name: AppRoutes.login,
  page: () => const LoginView(),
  transition: Transition.rightToLeft,
  transitionDuration: const Duration(milliseconds: 300),
)
```

## Gestion du Stack

- `Get.to()` : Ajoute à la pile
- `Get.off()` : Remplace le dernier
- `Get.offAll()` : Vide la pile et met la nouvelle page
- `Get.back()` : Retour d'un niveau

## Avantages

- **Simple** : Pas besoin de context
- **Typé** : Routes nommées évitent les erreurs
- **Flexible** : Arguments de tout type
- **Animé** : Transitions fluides intégrées
