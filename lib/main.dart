import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/screen/login_view.dart';
import 'package:workmanager/workmanager.dart';

import 'screen/home_page.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

BuildContext get currentContext => _navigatorKey.currentContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager.initialize(backgroundtask, isInDebugMode: false);
  BackgroundWorkManager.regisMultiTask();
  BackgroundWorkManager.initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          FirebaseAuth.instance.currentUser != null ? HomePage() : LoginView(),
    );
  }
}
