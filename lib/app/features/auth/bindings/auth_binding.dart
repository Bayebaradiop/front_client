import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../controllers/auth_controller.dart';
import '../repository/auth_repository.dart';
import '../viewmodel/auth_viewmodel.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find<ApiService>()));
    Get.lazyPut<AuthViewModel>(() => AuthViewModel(Get.find<AuthRepository>()));
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthViewModel>()));
  }
}
