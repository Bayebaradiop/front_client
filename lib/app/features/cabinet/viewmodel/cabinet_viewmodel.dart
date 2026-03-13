import 'package:get/get.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/specialite_model.dart';
import '../../../translate/translation_keys.dart';
import '../repository/cabinet_repository.dart';

class CabinetViewModel extends GetxController {
  final CabinetRepository _repo;

  CabinetViewModel(this._repo);

  final cabinets = <CabinetModel>[].obs;
  final specialitesDuCabinet = <SpecialiteModel>[].obs;
  final isLoading = false.obs;
  final isLoadingSpecialites = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCabinets();
  }

  Future<String?> fetchCabinets() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _repo.getCabinets();
      if (response.statusCode == 200) {
        final List data = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        cabinets.value =
            data.map((e) => CabinetModel.fromJson(e)).toList();
        return null;
      } else {
        final msg = response.body?['message'] ?? Tr.loadingCabinetsError.tr;
        errorMessage.value = msg;
        return msg;
      }
    } catch (e) {
      final msg = Tr.connectionError.tr;
      errorMessage.value = msg;
      return msg;
    } finally {
      isLoading.value = false;
    }
  }


  Future<String?> fetchSpecialitesByCabinet(int cabinetId) async {
    isLoadingSpecialites.value = true;
    try {
      final response = await _repo.getSpecialitesByCabinet(cabinetId);
      if (response.statusCode == 200) {
        final List data = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        specialitesDuCabinet.value =
            data.map((e) => SpecialiteModel.fromJson(e)).toList();
        return null;
      } else {
        final msg = response.body?['message'] ?? Tr.loadingSpecialtiesError.tr;
        return msg;
      }
    } catch (e) {
      return Tr.connectionError.tr;
    } finally {
      isLoadingSpecialites.value = false;
    }
  }
}
