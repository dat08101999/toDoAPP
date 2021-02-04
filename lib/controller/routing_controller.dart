import 'package:get/get.dart';
import 'package:todo_app/models/login_models.dart';
import 'package:todo_app/screen/home_page.dart';
import 'package:todo_app/screen/login_view.dart';

class RoutingController {
  static userIsLoginRouting() async {
    if (await LoginModels().useIsLogin() == true ||
        await LoginModels().userIsLoginWithFacebook()) Get.off(HomePage());
  }

  static toLoginView() {
    Get.off(LoginView());
  }

  static toHomeView() {
    Get.to(HomePage());
  }
}
