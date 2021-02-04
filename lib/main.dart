import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/routing_controller.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/login_models.dart';
import 'package:todo_app/screen/login_view.dart';
import 'package:workmanager/workmanager.dart';

import 'screen/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager.initialize(backgroundtask, isInDebugMode: false);
  BackgroundWorkManager.regisMultiTask();
  BackgroundWorkManager.initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  void inra() async {
    print(LoginModels().getUser().providerData);
  }

  @override
  Widget build(BuildContext context) {
    inra();
    RoutingController.userIsLoginRouting();
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          FirebaseAuth.instance.currentUser != null ? HomePage() : LoginView(),
    );
  }
}
