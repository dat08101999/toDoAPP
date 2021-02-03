import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/LoginConfig.dart';
import 'package:todo_app/controller/LoginController.dart';
import 'package:todo_app/controller/RoutingController.dart';
import 'package:todo_app/screen/SignUpView.dart';
import 'package:todo_app/widget/Loginwidget.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool appOpen = true;
  horizoltalLine() {
    return Container(
      color: LoginConfig.logintheme,
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
    // TODO: implement initState
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
        body: SingleChildScrollView(
      child: Column(children: [
        animatedBegin(
            appOpen,
            Container(
                height: 300,
                color: LoginConfig.logintheme,
                child: Center(
                  child: Text(
                      'Hello Welcome to ToDoApp , hope you have a nice day'),
                )),
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
    ));
  }
}
