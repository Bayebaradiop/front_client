# 3. Obx() et GetX() - Mise à jour automatique de l'UI

## Obx() Widget

`Obx()` wrap les widgets qui doivent réagir aux changements d'état.

## Exemple dans HomeView

Regardez `lib/app/features/home/views/home_view.dart` :

```dart
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      // Onglet actuel qui change automatiquement
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          _HomeContent(controller: controller),
          const MesRdvView(embedded: true),
          _SearchContent(controller: controller),
          _ProfileContent(controller: controller),
        ],
      )),

      // Barre de navigation qui se met à jour
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
        items: [...],
      )),
    );
  }
}
```

## Différence Obx vs GetX

- `Obx()` : Pour un seul widget, plus léger
- `GetX()` : Peut accéder au controller directement

```dart
// Avec GetX
GetX<HomeController>(
  builder: (controller) => Text(controller.currentUser.value?.prenom ?? ''),
)

// Avec Obx
Obx(() {
  final controller = Get.find<HomeController>();
  return Text(controller.currentUser.value?.prenom ?? '');
})
```

## Performance

Seuls les widgets dans `Obx()` se mettent à jour, pas toute l'arborescence !