import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/auth/views/splash_view.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/register_view.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/home/views/home_view.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/cabinet/views/cabinets_view.dart';
import '../features/cabinet/views/cabinet_detail_view.dart';
import '../features/cabinet/bindings/cabinet_binding.dart';
import '../features/specialite/views/specialites_view.dart';
import '../features/medecin/views/medecins_view.dart';
import '../features/medecin/views/medecin_detail_view.dart';
import '../features/medecin/bindings/medecin_binding.dart';
import '../features/rendezvous/views/mes_rdv_view.dart';
import '../features/rendezvous/views/rdv_detail_view.dart';
import '../features/rendezvous/bindings/rendezvous_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.cabinets,
      page: () => const CabinetsView(),
      binding: CabinetBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.cabinetDetail,
      page: () => const CabinetDetailView(),
      binding: CabinetBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.specialites,
      page: () => const SpecialitesView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.medecins,
      page: () => const MedecinsView(),
      binding: MedecinBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.medecinDetail,
      page: () => const MedecinDetailView(),
      binding: MedecinBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.mesRdv,
      page: () => const MesRdvView(),
      binding: RendezvousBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.rdvDetail,
      page: () => const RdvDetailView(),
      binding: RendezvousBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
