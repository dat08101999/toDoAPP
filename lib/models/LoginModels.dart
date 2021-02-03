import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginModels {
  static String loginError = '';
  static String wrongpassword = 'Mật khẩu sai';
  static String userNotFound = 'Không tồn tại người dùng';
  static String userIsAvaiable = 'Tài khoản đã tồn tại';
  static String weakPassword = 'Mật khẩu yếu';

  createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      loginError = '';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          loginError = weakPassword;
          break;
        case 'email-already-in-use':
          loginError = userIsAvaiable;
          break;
        default:
          loginError = 'have some errors here';
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
      loginError = '';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          loginError = userNotFound;
          break;
        case 'wrong-password':
          loginError = wrongpassword;
          break;
        default:
          loginError = 'unauthorize ';
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final FacebookLogin facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email', "public_profile"]);
    //Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);
    // Once signed in, return the UserCredential
    var curentuser = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    return curentuser;
  }

  facebookSignout() {
    FacebookLogin().logOut();
    FirebaseAuth.instance.signOut();
  }

  Future<bool> useIsLoginWithFaceBook() async {
    if (getUser() != null)
      return true;
    else
      return false;
  }

  User getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
