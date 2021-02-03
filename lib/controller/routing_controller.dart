import 'package:get/get.dart';
import 'package:todo_app/models/LoginModels.dart';
import 'package:todo_app/screen/home_page.dart';
import 'package:todo_app/screen/login_view.dart';

class RoutingController {
  static userIsLoginRouting() async {
    if (await LoginModels().useIsLogin() == true) Get.off(HomePage());
  }

  static toLoginView() {
    Get.off(LoginView());
  }

  static toHomeView() {
    Get.to(HomePage());
  }
}
