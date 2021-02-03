import 'package:get/get.dart';
import 'package:todo_app/models/LoginModels.dart';
import 'package:todo_app/screen/LoginView.dart';
import 'package:todo_app/screen/SignUpView.dart';
import 'package:todo_app/screen/home_page.dart';

class RoutingController {
  static userIsLoginRouting() async {
    if (await LoginModels().useIsLoginWithFaceBook() == true)
      Get.off(HomePage());
  }

  static toLoginView() {
    Get.off(LoginView());
  }

  static toSignUpView() {
    Get.to(SignUpView());
  }

  static toHomeView() {
    Get.to(HomePage());
  }
}
