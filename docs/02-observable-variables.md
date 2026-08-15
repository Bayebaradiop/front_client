# 2. Variables Observables (.obs)

## Le Concept

Les variables `.obs` sont au cœur de GetX. Elles permettent à l'UI de se mettre à jour automatiquement.

## Dans HomeController

Regardez `lib/app/features/home/controllers/home_controller.dart` :

```dart
class HomeController extends GetxController {
  // Variable observable pour l'onglet actuel
  final RxInt currentIndex = 0.obs;

  // Liste observable de médecins
  final RxList<MedecinModel> medecins = <MedecinModel>[].obs;

  // Booléen observable pour le chargement
  final RxBool isLoading = true.obs;

  // Objet complexe observable
  final Rxn<AuthModel> currentUser = Rxn<AuthModel>();
}
```

## Types d'Observables

- `RxInt`, `RxString`, `RxBool` : Types primitifs
- `RxList<T>` : Listes observables
- `Rxn<T>` : Nullable (peut être null)
- `.obs` : Extension sur n'importe quel objet

## Comment ça marche ?

Quand vous changez la valeur :
```dart
currentIndex.value = 1;  // L'UI se met à jour automatiquement
```

L'UI qui utilise `Obx()` ou `GetX()` se rafraîchit automatiquement !