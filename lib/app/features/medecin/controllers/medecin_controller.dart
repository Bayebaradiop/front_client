import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../routes/app_routes.dart';
import '../../../translate/translation_keys.dart';
import '../viewmodel/medecin_viewmodel.dart';
import '../../rendezvous/viewmodel/rendezvous_viewmodel.dart';
import '../../rendezvous/controllers/rendezvous_controller.dart';
import '../../home/controllers/home_controller.dart';

class MedecinController extends GetxController with SnackbarMixin {
  final MedecinViewModel _viewModel;
  final RendezvousViewModel _rdvViewModel;

  MedecinController(this._viewModel, this._rdvViewModel);

  // Indicateurs de chargement
  RxBool get isLoading => _viewModel.isLoading;
  RxBool get isLoadingCreneaux => _viewModel.isLoadingDispos;

  final selectedSpecialiteId = Rxn<int>();
  final selectedCabinetId = Rxn<int>();
  final selectedMedecin = Rxn<Map<String, dynamic>>();

  // Données créneaux pour la page détail
  final selectedDate = DateTime.now().obs;
  final selectedCreneau = Rxn<Map<String, dynamic>>();
  final motifController = ''.obs;
  final isBooking = false.obs;

  // Médecins convertis en Map pour les vues
  final medecins = <Map<String, dynamic>>[].obs;
  final specialitesFilter = <Map<String, dynamic>>[].obs;

  final creneaux = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get medecinsFiltres {
    return medecins.where((m) {
      if (selectedSpecialiteId.value != null &&
          m['specialiteId'] != selectedSpecialiteId.value) {
        return false;
      }
      if (selectedCabinetId.value != null &&
          m['cabinetId'] != selectedCabinetId.value) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args.containsKey('specialiteId')) {
        selectedSpecialiteId.value = args['specialiteId'];
      }
      if (args.containsKey('cabinetId')) {
        selectedCabinetId.value = args['cabinetId'];
      }
      if (args.containsKey('medecin')) {
        selectedMedecin.value = args['medecin'];
        loadCreneaux();
      }
    }
    _loadMedecins();
  }

  Future<void> _loadMedecins() async {
    final error = await _viewModel.fetchMedecins(
      specialiteId: selectedSpecialiteId.value,
      cabinetId: selectedCabinetId.value,
    );
    if (error != null) {
      showError(error);
    } else {
      // Convertir les modèles en Map pour les vues
      medecins.value = _viewModel.medecins
          .map((m) => {
                'id': m.id,
                'prenom': m.prenom ?? '',
                'nom': m.nom ?? '',
                'photo': m.photo,
                'telephone': m.telephone ?? '',
                'email': m.email ?? '',
                'specialiteId': m.specialiteId,
                'specialiteNom': m.specialiteNom ?? '',
                'cabinetId': m.cabinetId,
                'cabinetNom': m.cabinetNom ?? '',
              })
          .toList();
      // Reconstruire les filtres de spécialités depuis les données réelles
      final specs = <Map<String, dynamic>>[{'id': null, 'nom': Tr.allFilter.tr}];
      final seen = <int?>{};
      for (final m in _viewModel.medecins) {
        if (!seen.contains(m.specialiteId)) {
          seen.add(m.specialiteId);
          specs.add({'id': m.specialiteId, 'nom': m.specialiteNom ?? ''});
        }
      }
      specialitesFilter.value = specs;
    }
  }

  Future<void> refresh() async {
    await _loadMedecins();
  }

  void filterBySpecialite(int? specialiteId) {
    selectedSpecialiteId.value = specialiteId;
  }

  void selectMedecin(Map<String, dynamic> medecin) {
    selectedMedecin.value = medecin;
    loadCreneaux();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    loadCreneaux();
  }

  Future<void> loadCreneaux() async {
    final medecinId = selectedMedecin.value?['id'] as int?;
    if (medecinId == null) return;

    final date = selectedDate.value;
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final error = await _viewModel.fetchDisponibilites(medecinId, date: dateStr);
    if (error != null) {
      showError(error);
      return;
    }

    creneaux.value = _viewModel.disponibilites
        .map((c) => {
              'id': c.id,
              'date': c.date,
              'heureDebut': c.heureDebut,
              'heureFin': c.heureFin,
              'disponible': c.disponible,
              'medecinId': c.medecinId,
              'medecinNom': c.medecinNom,
              'medecinPrenom': c.medecinPrenom,
            })
        .toList();
  }

  void selectCreneau(Map<String, dynamic> creneau) {
    if (creneau['disponible'] == true) {
      selectedCreneau.value = creneau;
    }
  }

  Future<void> confirmBooking() async {
    if (selectedCreneau.value == null) {
      showError(Tr.selectSlotError.tr);
      return;
    }
    if (motifController.value.isEmpty) {
      showError(Tr.enterReasonError.tr);
      return;
    }

    isBooking.value = true;
    final error = await _rdvViewModel.createRdv({
      'creneauId': selectedCreneau.value!['id'],
      'motif': motifController.value,
    });
    isBooking.value = false;

    if (error != null) {
      showError(error);
      return;
    }

    // Retourner à home et afficher l'onglet RDV
    Get.until((route) => route.settings.name == AppRoutes.home);
    Get.find<HomeController>().changeTab(1);
    // Rafraîchir la liste des RDV
    try {
      Get.find<RendezvousController>().refresh();
    } catch (_) {}
    showSuccess(Tr.appointmentConfirmed.tr, Tr.appointmentConfirmedMsg.tr);
  }
}
