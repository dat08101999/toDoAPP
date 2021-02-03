import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/login_config.dart';
import 'package:todo_app/controller/login_controller.dart';
import 'package:todo_app/models/login_models.dart';
import 'package:todo_app/widget/widget_login.dart';
import 'package:todo_app/widget/widget_showdialog.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController acceptedPassword = TextEditingController();
  LoginController loginController = Get.find();

  signUponpress(context) async {
    if (acceptedPassword.text != password.text) {
      ShowDialogWidget.showDialogResuld(context, 'Xác nhận mật khẩu sai', '');
      return;
    }
    ShowDialogWidget.showDialogloading(context, 'Vui lòng chờ');
    await Future.delayed(Duration(seconds: 2));
    await LoginModels().createUser(username.text, password.text);
    print(LoginModels.error);
    Navigator.of(context).pop();
    if (LoginModels.error != '')
      ShowDialogWidget.showDialogResuld(context, 'Thất bại', LoginModels.error);
    else {
      LoginModels().sendVetifiEmail(context);
      ShowDialogWidget.showDialogAcept(
          context,
          'Một email đã được gửi đến bạn, vui lòng kiểm tra và quay lại app đăng nhập sau',
          'Xác nhận', () {
        Navigator.of(context).pop();
        LoginModels().vetifiEmailTimer();
      });
    }
  }

  signInpress(context) {
    loginController.changeSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: LoginConfig.logintheme,
      decoration: LoginConfig.decorationColors(),
      child: Container(
        height: LoginConfig.textFieldAreaHeigth *
            MediaQuery.of(context).size.height,
        //color: LoginConfig.logintheme,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
            ),
            LoginWidget().textFiled(
                'username', Icon(Icons.person), username, context, false),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            LoginWidget().textFiled('password', loginController.passwordIcon,
                password, context, true),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            LoginWidget().textFiled('acccepted password',
                loginController.passwordIcon, acceptedPassword, context, true),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            SizedBox(
              child: Column(
                children: [
                  LoginWidget().buttonCustom(context, 'Đăng kí', signUponpress),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  LoginWidget().buttonCustom(context, 'Đăng nhập', signInpress)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
