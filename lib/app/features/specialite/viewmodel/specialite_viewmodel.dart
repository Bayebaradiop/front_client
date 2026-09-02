import 'package:get/get.dart';
import '../../../core/utils/error_utils.dart';
import '../../../models/specialite_model.dart';
import '../../../translate/translation_keys.dart';
import '../repository/specialite_repository.dart';

class SpecialiteViewModel extends GetxController {
  final SpecialiteRepository _repo;
  SpecialiteViewModel(this._repo);

  final specialites = <SpecialiteModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();


  Future<String?> fetchSpecialites() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final response = await _repo.getSpecialites();
      if (response.statusCode == 200) {
        final List data = response.body['data'] ?? [];
        specialites.value = List<SpecialiteModel>.from(
          data.map((e) => SpecialiteModel.fromJson(e)),
        );
        return null;
      } else {
        return ErrorUtils.extractApiError(response, Tr.loadingSpecialtiesError.tr);
      }
    } catch (e) {
      return ErrorUtils.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

}
