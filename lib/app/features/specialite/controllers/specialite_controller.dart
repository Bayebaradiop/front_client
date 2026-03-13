import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../models/specialite_model.dart';
import '../viewmodel/specialite_viewmodel.dart';

class SpecialiteController extends GetxController with SnackbarMixin {
  final SpecialiteViewModel _viewModel;
  SpecialiteController(this._viewModel);

  List<SpecialiteModel> get specialites => _viewModel.specialites;
  bool get isLoading => _viewModel.isLoading.value;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  Future<void> refresh() async {
    final error = await _viewModel.fetchSpecialites();
    if (error != null) {
      showError(error);
    }
  }
}
