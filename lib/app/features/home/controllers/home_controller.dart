import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/medecin_model.dart';
import '../../../models/specialite_model.dart';
import '../../../models/rendezvous_model.dart';
import '../../../models/auth_model.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeController extends GetxController with SnackbarMixin {
  final HomeViewModel _viewModel;

  HomeController(this._viewModel);

  // Raccourcis vers le ViewModel
  RxBool get isLoading => _viewModel.isLoading;
  RxList<CabinetModel> get cabinets => _viewModel.cabinets;
  RxList<SpecialiteModel> get specialites => _viewModel.specialites;
  RxList<MedecinModel> get medecins => _viewModel.medecins;
  Rxn<RendezVousModel> get prochainRdv => _viewModel.prochainRdv;
  Rxn<AuthModel> get currentUser => _viewModel.currentUser;

  // État UI propre au controller
  final currentIndex = 0.obs;

  // Search
  final searchQuery = ''.obs;
  final searchFilter = 'all'.obs; // 'all', 'doctors', 'cabinets', 'specialties'

  List<MedecinModel> get filteredMedecins {
    if (searchQuery.value.isEmpty) return medecins;
    final q = searchQuery.value.toLowerCase();
    return medecins.where((m) {
      final name = '${m.prenom ?? ''} ${m.nom ?? ''}'.toLowerCase();
      final spec = (m.specialiteNom ?? '').toLowerCase();
      final cab = (m.cabinetNom ?? '').toLowerCase();
      return name.contains(q) || spec.contains(q) || cab.contains(q);
    }).toList();
  }

  List<CabinetModel> get filteredCabinets {
    if (searchQuery.value.isEmpty) return cabinets;
    final q = searchQuery.value.toLowerCase();
    return cabinets.where((c) {
      final name = (c.nom ?? '').toLowerCase();
      final addr = (c.adresse ?? '').toLowerCase();
      return name.contains(q) || addr.contains(q);
    }).toList();
  }

  List<SpecialiteModel> get filteredSpecialites {
    if (searchQuery.value.isEmpty) return specialites;
    final q = searchQuery.value.toLowerCase();
    return specialites.where((s) {
      return (s.nom ?? '').toLowerCase().contains(q);
    }).toList();
  }

  bool get hasSearchResults {
    if (searchFilter.value == 'doctors') return filteredMedecins.isNotEmpty;
    if (searchFilter.value == 'cabinets') return filteredCabinets.isNotEmpty;
    if (searchFilter.value == 'specialties') return filteredSpecialites.isNotEmpty;
    return filteredMedecins.isNotEmpty || filteredCabinets.isNotEmpty || filteredSpecialites.isNotEmpty;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> refresh() async {
    final error = await _viewModel.fetchAll();
    if (error != null) {
      showError(error);
    }
  }
}
