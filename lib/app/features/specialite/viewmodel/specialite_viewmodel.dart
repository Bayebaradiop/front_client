import 'package:get/get.dart';
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
        specialites.value =
            data.map((e) => SpecialiteModel.fromJson(e)).toList();
        return null;
      } else {
        return response.body?['message'] ?? Tr.loadingError.tr;
      }
    } catch (e) {
      return Tr.connectionError.tr;
    } finally {
      isLoading.value = false;
    }
  }

}
