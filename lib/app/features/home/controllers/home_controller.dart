import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final isLoading = false.obs;
  final userName = 'Fatou'.obs;

  // Données mock cabinets
  final cabinets = <Map<String, dynamic>>[
    {
      'id': 1,
      'nom': 'Cabinet Médical Medibook',
      'adresse': '123 Avenue de la Santé, Dakar',
      'telephone': '+221 33 123 45 67',
      'email': 'contact@medibook.com',
      'couleurPrimaire': '#007bff',
      'couleurSecondaire': '#ffffff',
    },
    {
      'id': 2,
      'nom': 'Clinique du Plateau',
      'adresse': '45 Rue Carnot, Dakar Plateau',
      'telephone': '+221 33 456 78 90',
      'email': 'contact@plateau-clinique.com',
      'couleurPrimaire': '#6f42c1',
      'couleurSecondaire': '#ffffff',
    },
    {
      'id': 3,
      'nom': 'Centre Médical Almadies',
      'adresse': '78 Route des Almadies, Dakar',
      'telephone': '+221 33 789 01 23',
      'email': 'contact@almadies-medical.com',
      'couleurPrimaire': '#e83e8c',
      'couleurSecondaire': '#ffffff',
    },
  ].obs;

  // Données mock spécialités
  final specialites = <Map<String, dynamic>>[
    {'id': 1, 'nom': 'Médecine Générale', 'icon': 'medical'},
    {'id': 2, 'nom': 'Cardiologie', 'icon': 'heart'},
    {'id': 3, 'nom': 'Dermatologie', 'icon': 'skin'},
    {'id': 4, 'nom': 'Pédiatrie', 'icon': 'baby'},
    {'id': 5, 'nom': 'Ophtalmologie', 'icon': 'eye'},
    {'id': 6, 'nom': 'Dentisterie', 'icon': 'tooth'},
  ].obs;

  // Prochain RDV mock
  final prochainRdv = Rxn<Map<String, dynamic>>({
    'id': 7,
    'statut': 'CONFIRME',
    'motif': 'Consultation générale',
    'date': '2026-03-15',
    'heureDebut': '09:00:00',
    'heureFin': '09:30:00',
    'medecinNom': 'Dupont',
    'medecinPrenom': 'Jean',
    'medecinSpecialite': 'Médecine Générale',
    'cabinetNom': 'Cabinet Médical Medibook',
  });

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void simulateLoading() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoading.value = false;
    });
  }

  @override
  void onInit() {
    super.onInit();
    simulateLoading();
  }
}
