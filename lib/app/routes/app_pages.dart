import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../widgets/display_camera.dart';

part 'app_routes.dart';

class AppPages {
  GetStorage box = GetStorage();

  late final INITIAL = box.hasData("userData") ? Routes.HOME : Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.TAKEPICTURE,
      page: () => TakePictureScreen(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
  ];
}
