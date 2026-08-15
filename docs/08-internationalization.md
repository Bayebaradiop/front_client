# 8. Internationalisation avec GetX

## Configuration dans main.dart

Regardez `lib/main.dart` :

```dart
runApp(
  GetMaterialApp(
    // Configuration i18n
    translations: AppTranslations(),
    locale: const Locale('fr', 'FR'),
    fallbackLocale: const Locale('fr', 'FR'),
    // ...
  ),
);
```

## Classe AppTranslations

Regardez `lib/app/translate/app_translations.dart` :

```dart
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'fr_FR': french,
    'en_US': english,
  };
}
```

## Fichiers de Traduction

Regardez `lib/app/translate/french.dart` :

```dart
const Map<String, String> french = {
  // Authentification
  'login': 'Connexion',
  'register': 'Inscription',
  'email': 'Email',
  'password': 'Mot de passe',

  // Navigation
  'home': 'Accueil',
  'appointments': 'Rendez-vous',
  'search': 'Recherche',
  'profile': 'Profil',

  // Home
  'nextAppointment': 'Prochain rendez-vous',
  'medicalCabinets': 'Cabinets médicaux',
  'specialties': 'Spécialités',
  'doctors': 'Médecins',

  // Actions
  'seeAll': 'Voir tout',
  'searchDoctorSpecialty': 'Rechercher un médecin ou une spécialité',
  'phone': 'Téléphone',
  'email': 'Email',
};
```

## Utilisation dans les Vues

```dart
// Dans les widgets
Text(Tr.login.tr)  // "Connexion"

// Avec paramètres
Text(Tr.welcome.trParams({'name': user.name}))

// Dans BottomNavigationBar
BottomNavigationBarItem(
  label: Tr.home.tr,
  // ...
)
```

## Changement de Langue

```dart
// Changer la locale
Get.updateLocale(const Locale('en', 'US'));

// Locale actuelle
final currentLocale = Get.locale;
```

## Avantages

- **Typé** : Pas d'erreurs de clés
- **Réactif** : Change automatiquement partout
- **Organisé** : Fichiers séparés par langue
- **Complet** : Intégré avec GetX

Dans MediBook, toute l'interface est traduite en français avec support pour l'anglais !
