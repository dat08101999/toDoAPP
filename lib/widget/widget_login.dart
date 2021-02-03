import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/login_config.dart';
import 'package:todo_app/controller/login_controller.dart';
import 'package:todo_app/controller/routing_controller.dart';
import 'package:todo_app/models/login_models.dart';
import 'package:todo_app/widget/widget_showdialog.dart';

class LoginWidget {
  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  LoginController loginController = Get.put(LoginController());

  Widget textFiled(String hintText, Icon icon, TextEditingController controller,
      context, bool ispassword) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: LoginConfig.borderSideTextFiled,
              left: LoginConfig.borderSideTextFiled,
              right: LoginConfig.borderSideTextFiled,
              top: LoginConfig.borderSideTextFiled),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextField(
            obscureText: ispassword ? loginController.passwordHide : false,
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                icon: InkWell(
                    onTap: () {
                      if (ispassword) {
                        loginController.changeHidePassword();
                      }
                    },
                    child: icon))),
      ),
    );
  }

  loginbutonOnpress(context) async {
    ShowDialogWidget.showDialogloading(context, 'Đang kiểm tra');
    await LoginModels().signInWithAccount(email.text, password.text);
    await Future.delayed(Duration(seconds: 1));
    print(LoginModels.error);
    Navigator.of(context).pop();
    if (await LoginModels().useIsLogin() != false)
      RoutingController.toHomeView();
    else {
      if (LoginModels.error == '') {
        await ShowDialogWidget.showDialogAcept(
            context, 'email chưa được xác thực', 'click để xác thực email', () {
          LoginModels().sendVetifiEmail(context);
          LoginModels().vetifiEmailTimer();
        });
        return;
      }
      ShowDialogWidget.showDialogResuld(context, 'Thất Bại', LoginModels.error);
    }
  }

  buttonCustom(context, String text, Function(BuildContext context) onpress) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[400],
      ),
      child: FlatButton(
        onPressed: () async {
          onpress(context);
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldArea(context) {
    return Container(
      decoration: LoginConfig.decorationColors(),
      // color: LoginConfig.logintheme,
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height * LoginConfig.textFieldAreaHeigth,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
            ),
            LoginConfig.loginTexttitle(),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            textFiled('email', Icon(Icons.person), email, context, false),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            GetBuilder<LoginController>(
              builder: (builder) {
                return textFiled('password', loginController.passwordIcon,
                    password, context, true);
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                      onTap: () {
                        ShowDialogWidget.showDiaLogResetPassword(
                            context, email);
                      },
                      child: Text('Quên mật khẩu?'))),
            ),
            Padding(
              padding: EdgeInsets.all(30),
            ),
            buttonCustom(context, 'Đăng Nhập', loginbutonOnpress),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            InkWell(
                onTap: () {
                  loginController.changeSignUp();
                },
                child: Text("Chưa có tài khoản, đăng kí ngay")),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text('Cần trợ giúp?'),
            ),
          ],
        ),
      ),
    );
  }

  Widget logoArea(context) {
    return SafeArea(
      child: Container(
        height: LoginConfig.logoSize,
        width: LoginConfig.logoSize,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Widget buildHeaderArea(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: LoginConfig.decorationColors(),
      //color: LoginConfig.logintheme,
      height: MediaQuery.of(context).size.height * LoginConfig.headerHeigth,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoArea(context),
            Padding(
                padding: EdgeInsets.only(
              top: LoginConfig.headerPadding,
            )),
            SignInButton(
              Buttons.Facebook,
              text: 'Đăng nhập bằng facebook',
              //mini: true,
              onPressed: () async {
                await LoginModels().signInWithFacebook();
                if (LoginModels().getUser() != null)
                  RoutingController.toHomeView();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return FlatButton(
      child: Text('Sign Out'),
      onPressed: () async {
        await LoginModels().facebookSignout();
        RoutingController.toLoginView();
      },
    );
  }
}
