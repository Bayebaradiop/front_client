# 7. Repositories - Couche Données

## Rôle du Repository

Le repository gère les appels API et la logique de données, séparant la logique métier des détails d'implémentation.

## Exemple HomeRepository

Regardez `lib/app/features/home/repository/home_repository.dart` :

```dart
class HomeRepository {
  final ApiService _api = Get.find<ApiService>();

  Future<List<MedecinModel>> getMedecins() async {
    try {
      final response = await _api.get('/medecins');
      return (response.data as List)
          .map((json) => MedecinModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur chargement médecins: $e');
    }
  }

  Future<List<CabinetModel>> getCabinets() async {
    final response = await _api.get('/cabinets');
    return (response.data as List)
        .map((json) => CabinetModel.fromJson(json))
        .toList();
  }

  Future<List<SpecialiteModel>> getSpecialites() async {
    final response = await _api.get('/specialites');
    return (response.data as List)
        .map((json) => SpecialiteModel.fromJson(json))
        .toList();
  }
}
```

## Utilisation dans le Controller

```dart
class HomeController extends GetxController {
  final HomeRepository repository = Get.find<HomeRepository>();

  Future<void> loadData() async {
    try {
      final medecins = await repository.getMedecins();
      final cabinets = await repository.getCabinets();
      final specialites = await repository.getSpecialites();

      this.medecins.assignAll(medecins);
      this.cabinets.assignAll(cabinets);
      this.specialites.assignAll(specialites);
    } catch (e) {
      // Gestion d'erreur
      Get.snackbar('Erreur', 'Impossible de charger les données');
    }
  }
}
```

## Avantages de cette Architecture

### Séparation des Responsabilités
- **Controller** : Logique métier, état UI
- **Repository** : Appels API, transformation données
- **View** : Affichage uniquement

### Testabilité
```dart
// Test facile du controller en mockant le repository
final mockRepo = MockHomeRepository();
Get.put<HomeRepository>(mockRepo);
```

### Réutilisabilité
Le même repository peut être utilisé dans plusieurs controllers.

### Maintenance
Changement d'API ? Seul le repository change, pas les controllers.
