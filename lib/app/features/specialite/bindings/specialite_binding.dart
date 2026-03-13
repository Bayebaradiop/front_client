import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../repository/specialite_repository.dart';
import '../viewmodel/specialite_viewmodel.dart';
import '../controllers/specialite_controller.dart';

class SpecialiteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<SpecialiteRepository>(
        () => SpecialiteRepository(Get.find<ApiService>()));
    Get.lazyPut<SpecialiteViewModel>(
        () => SpecialiteViewModel(Get.find<SpecialiteRepository>()));
    Get.lazyPut<SpecialiteController>(
        () => SpecialiteController(Get.find<SpecialiteViewModel>()));
  }
}
