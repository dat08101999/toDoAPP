import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/login_config.dart';
import 'package:todo_app/controller/login_controller.dart';
import 'package:todo_app/controller/routing_controller.dart';
import 'package:todo_app/models/loading.dart';
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
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          obscureText: ispassword ? loginController.passwordHide : false,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none),
            hintText: hintText,
            icon: InkWell(
                onTap: () {
                  if (ispassword) {
                    loginController.changeHidePassword();
                  }
                },
                child: icon),
          ),
        ),
      ),
    );
  }

  loginbutonOnpress(context) async {
    Loading.show(newTitle: 'Đang kiểm tra');
    await LoginModels().signInWithAccount(email.text, password.text);
    await Future.delayed(Duration(seconds: 1));
    print(LoginModels.error);
    Loading.dismiss();
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

  Widget buttonCustom(
      context, String text, Function(BuildContext context) onpress) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.07,
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

  ///* from login
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
            //* Wellcome
            Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: LoginConfig.loginTexttitle()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  textFiled('Email', Icon(Icons.person), email, context, false),
            ),
            GetBuilder<LoginController>(
              builder: (builder) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: textFiled('Password', loginController.passwordIcon,
                      password, context, true),
                );
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              width: MediaQuery.of(context).size.width * 0.7,
              child: InkWell(
                  onTap: () {
                    ShowDialogWidget.showDiaLogResetPassword(context, email);
                  },
                  child: Text('Quên mật khẩu?')),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: buttonCustom(context, 'Đăng Nhập', loginbutonOnpress),
            ),
            InkWell(
                onTap: () {
                  loginController.changeSignUp();
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Chưa có tài khoản,",
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: ' Đăng kí ngay !',
                        style: TextStyle(color: Colors.blue))
                  ]),
                )),
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
        margin: EdgeInsets.all(30),
        height: LoginConfig.logoSize,
        width: LoginConfig.logoSize,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(100)),
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
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              text: 'Đăng nhập bằng facebook',
              //mini: true,
              onPressed: () async {
                await LoginModels().signInWithFacebook();
                if (LoginModels().getUser() != null) {
                  RoutingController.toHomeView();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
