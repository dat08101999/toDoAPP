import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //LoginController instance = Get.put(LoginController());
  Icon passwordIcon = Icon(Icons.lock);
  bool passwordHide = true;
  bool signUpIsActive = false;
  bool vetifiEmail = false;
  changeHidePassword() {
    passwordHide = !passwordHide;
    passwordIcon = passwordHide ? Icon(Icons.lock) : Icon(Icons.lock_outline);
    update();
  }

  changeSignUp() {
    signUpIsActive = !signUpIsActive;
    update();
  }
}
