import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/medecin_model.dart';
import '../../../models/specialite_model.dart';
import '../viewmodel/cabinet_viewmodel.dart';
import '../../home/controllers/home_controller.dart';

class CabinetController extends GetxController with SnackbarMixin {
  final CabinetViewModel _viewModel;

  CabinetController(this._viewModel);

  // Raccourcis vers le ViewModel
  RxList<CabinetModel> get cabinets => _viewModel.cabinets;
  RxList<SpecialiteModel> get specialitesDuCabinet => _viewModel.specialitesDuCabinet;
  RxBool get isLoading => _viewModel.isLoading;
  RxBool get isLoadingSpecialites => _viewModel.isLoadingSpecialites;

  // État UI propre au controller
  final selectedCabinet = Rxn<CabinetModel>();
  final selectedTab = 0.obs; // 0: Équipe, 1: Services, 2: Horaires

  List<MedecinModel> get medecinsDuCabinet {
    final cabId = selectedCabinet.value?.id;
    if (cabId == null) return [];
    try {
      final homeCtrl = Get.find<HomeController>();
      return homeCtrl.medecins.where((m) => m.cabinetId == cabId).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is CabinetModel) {
      selectedCabinet.value = Get.arguments as CabinetModel;
      loadSpecialites();
    }
  }

  Future<void> refresh() async {
    final error = await _viewModel.fetchCabinets();
    if (error != null) {
      showError(error);
    }
  }

  void selectCabinet(CabinetModel cabinet) {
    selectedCabinet.value = cabinet;
    selectedTab.value = 0;
    loadSpecialites();
  }

  Future<void> loadSpecialites() async {
    final id = selectedCabinet.value?.id;
    if (id == null) return;
    final error = await _viewModel.fetchSpecialitesByCabinet(id);
    if (error != null) {
      showError(error);
    }
  }
}
