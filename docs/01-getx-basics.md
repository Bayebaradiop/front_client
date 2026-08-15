# 1. Les Bases de GetX

## Qu'est-ce que GetX ?

GetX est un micro-framework Flutter qui fournit une solution complète pour :
- Gestion d'état réactive
- Navigation sans context
- Injection de dépendances
- Gestion de thèmes
- Internationalisation

## Pourquoi GetX dans MediBook ?

Dans MediBook, GetX est utilisé partout pour :
- Mettre à jour l'UI automatiquement quand les données changent
- Naviguer entre les écrans
- Gérer l'état de l'application (chargement, erreurs, etc.)
- Injecter les services (API, stockage, etc.)

## Exemple Simple

Regardez dans `lib/main.dart` :

```dart
void main() async {
  // Injection des controllers principaux
  final themeCtrl = Get.put(ThemeController());
  Get.put(NotificationController());

  runApp(MediBookApp());
}
```

`Get.put()` crée et enregistre une instance globale du controller.