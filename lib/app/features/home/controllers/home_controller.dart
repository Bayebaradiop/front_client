import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../models/cabinet_model.dart';
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
  Rxn<RendezVousModel> get prochainRdv => _viewModel.prochainRdv;
  Rxn<AuthModel> get currentUser => _viewModel.currentUser;

  // État UI propre au controller
  final currentIndex = 0.obs;

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
