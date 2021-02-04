import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:todo_app/controller/login_controller.dart';
import 'package:todo_app/controller/routing_controller.dart';
import 'package:todo_app/widget/widget_showdialog.dart';

class LoginModels {
  static String error = '';
  static String wrongpassword = 'Mật khẩu sai';
  static String userNotFound = 'Không tồn tại tài khoản';
  static String userIsAvaiable = 'Tài khoản đã tồn tại';
  static String weakPassword = 'Mật khẩu yếu';
  static String userisntVetifi = 'email chưa được xác thực';
  static String invalidEmail = 'Sai định dạng email';
  static String someThingError = 'Opps ! Có lỗi gì đó ?';
  LoginController loginController = LoginController();
  createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      error = '';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          error = weakPassword;
          break;
        case 'email-already-in-use':
          error = userIsAvaiable;
          break;
        default:
          error = someThingError;
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  signInWithAccount(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('ok');
      error = '';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          error = userNotFound;
          break;
        case 'wrong-password':
          error = wrongpassword;
          break;
        default:
          error = someThingError;
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final FacebookLoginResult facebookLogin =
        await FacebookLogin().logIn(['email', "public_profile"]);
    //Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(facebookLogin.accessToken.token);
    // Once signed in, return the UserCredential
    var curentuser = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    return curentuser;
  }

  static signOut() async {
    await FacebookLogin().logOut();
    await FirebaseAuth.instance.signOut();
  }

  userLoginWithFaceBook() {
    if (getUser().providerData[0].providerId == 'facebook.com') return true;
  }

  vetifiEmailTimer() {
    Future(() async {
      Timer.periodic(Duration(seconds: 3), (timer) async {
        FirebaseAuth.instance.currentUser..reload();
        var user = FirebaseAuth.instance.currentUser;
        if (user.emailVerified) {
          loginController.vetifiEmail = true;
          RoutingController.toHomeView();
          timer.cancel();
        }
      });
    });
  }

  sendVetifiEmail(context) {
    getUser().sendEmailVerification();
    ShowDialogWidget.showDialogResuld(context, 'Đã gửi yêu cầu xác thực',
        'vui lòng xác thực email trước khi đăng nhập lại');
  }

  Future<bool> userIsLoginWithFacebook() async {
    try {
      if (getUser().providerData[0].providerId == 'facebook.com') return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  sendPasswordResetRequest(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      error = '';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          error = userNotFound;
          break;
        case 'invalid-email':
          error = invalidEmail;
          break;
        default:
          error = someThingError;
          break;
      }
    }
  }

  bool useisVetifi() {
    return FirebaseAuth.instance.currentUser.emailVerified;
  }

  Future<bool> useIsLogin() async {
    if (getUser() != null && useisVetifi())
      return true;
    else
      return false;
  }

  User getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
