import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/login_config.dart';
import 'package:todo_app/controller/login_controller.dart';
import 'package:todo_app/controller/routing_controller.dart';
import 'package:todo_app/screen/signup_view.dart';
import 'package:todo_app/widget/widget_login.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool appOpen = true;

  //* dòng kẻ --------OR-----------
  horizoltalLine() {
    return Container(
      decoration: LoginConfig.decorationColors(),
      //color: LoginConfig.logintheme,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 1,
          width: 130.0,
          color: Colors.black,
        ),
        Text('  OR  '),
        Container(
          height: 1,
          width: 130.0,
          color: Colors.black,
        )
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    RoutingController.userIsLoginRouting();
  }

  Widget animatedBegin(
      bool condition, firstchild, secondchild, durationSecond) {
    return AnimatedCrossFade(
        firstCurve: Curves.easeInToLinear,
        secondCurve: Curves.easeInToLinear,
        duration: Duration(seconds: durationSecond),
        crossFadeState:
            condition ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: firstchild,
        secondChild: secondchild);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4));
      appOpen = false;
      setState(() {});
    });
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            animatedBegin(
                appOpen,
                Container(
                    decoration: LoginConfig.decorationColors(),
                    height: 300,
                    //color: LoginConfig.logintheme,
                    child: Center(
                      child: Text(
                          'Chào mừng đến ToDoApp,chúc bạn một ngày tốt lành!'),
                    )),

                ///* logo
                LoginWidget().buildHeaderArea(context),
                4),
            horizoltalLine(),
            GetBuilder<LoginController>(
              builder: (builder) {
                return animatedBegin(builder.signUpIsActive, SignUpView(),
                    LoginWidget().buildTextFieldArea(context), 1);
              },
            )
          ]),
        ),
      ),
    );
  }
}
