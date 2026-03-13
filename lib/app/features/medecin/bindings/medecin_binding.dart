import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../controllers/medecin_controller.dart';
import '../repository/medecin_repository.dart';
import '../viewmodel/medecin_viewmodel.dart';
import '../../rendezvous/repository/rendezvous_repository.dart';
import '../../rendezvous/viewmodel/rendezvous_viewmodel.dart';

class MedecinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<MedecinRepository>(
        () => MedecinRepository(Get.find<ApiService>()));
    Get.lazyPut<MedecinViewModel>(
        () => MedecinViewModel(Get.find<MedecinRepository>()));
    Get.lazyPut<RendezvousRepository>(
        () => RendezvousRepository(Get.find<ApiService>()));
    Get.lazyPut<RendezvousViewModel>(
        () => RendezvousViewModel(Get.find<RendezvousRepository>()));
    Get.lazyPut<MedecinController>(() => MedecinController(
          Get.find<MedecinViewModel>(),
          Get.find<RendezvousViewModel>(),
        ));
  }
}
