import 'package:get/get.dart';
import '../controllers/medecin_controller.dart';

class MedecinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedecinController>(() => MedecinController());
  }
}
