import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_home.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/screen/add_new_page.dart';
import 'package:todo_app/widget/widget_build_remote_month.dart';
import 'package:todo_app/widget/widget_build_scroll_date.dart';
import 'package:todo_app/widget/widget_build_task_item.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ControllerHome controllerHome;
  var tasks;
  int coutOnTap = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    controllerHome = Get.put(ControllerHome());
    tasks = FirebaseFirestore.instance
        .collection('tasks')
        .where('userid', isEqualTo: 'T7g1RTorhdbGkEozJGjcAuAbmFs1')
        .orderBy('expired_at', descending: false);
    controllerHome.initListDay();
    controllerHome = Get.put(ControllerHome());
    listenNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[200],
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(Icons.menu, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [Colors.blue[200], Colors.red[100]]),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: GetBuilder<ControllerHome>(builder: (ctl) {
            return Stack(
              children: [
                //* build tháng
                BuildReMoteMonth(),
                //* build ngày
                Container(
                    margin: EdgeInsets.only(top: 50), child: BuildScrollDate()),
                //* build task
                Container(
                  margin: EdgeInsets.only(top: 200),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: tasks.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Opps ! có lỗi gì đó'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data.docs[index]['expired_at']
                                      .toDate()
                                      .day ==
                                  controllerHome.currentDay &&
                              snapshot.data.docs[index]['expired_at']
                                      .toDate()
                                      .month ==
                                  controllerHome.currentMonth) {
                            return InkWell(
                                onTap: () async {
                                  coutOnTap++;
                                  if (coutOnTap == 1) {
                                    controllerHome.indexpage = index;
                                    controllerHome.actionActive = true;
                                  }
                                  if (coutOnTap == 2 &&
                                      controllerHome.indexpage == index) {
                                    controllerHome.actionActive = false;
                                    coutOnTap = 0;
                                  }
                                  if (coutOnTap == 2 &&
                                      controllerHome.indexpage != index) {
                                    controllerHome.indexpage = index;
                                    controllerHome.actionActive = true;
                                    coutOnTap = 1;
                                  }
                                },
                                child: BuildTaskItem(
                                    task: snapshot.data.docs[index],
                                    index: index));
                          }
                          return Text('');
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTasks();
          },
          child: Icon(Icons.add)),
    );
  }

  void addTasks() async {
    if (controllerHome.checkDate()) {
      Get.to(AddNewPage());
    } else {
      Flushbar(
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          backgroundColor: Colors.black54,
          title: 'Quá hạn',
          message: 'Không thể tạo lịch cho những ngày trước',
          duration: Duration(seconds: 3))
        ..show(context);
    }
  }

  void listenNotification() {
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }
    _firebaseMessaging.configure(

        //onMessage được gọi khi đang mở app
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage $message");
          BackgroundWorkManager.onNoticfication(
              message['notification']['title'],
              message['notification']['body']);
        },

        //onLaunch được gọi khi app đang đóng mà người dùng click vào thông báo
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch $message");
        },

        //onResume được gọi khi app đang mở dưới nền mà người dùng click vào thông báo
        onResume: (Map<String, dynamic> message) async {
          print("onResume $message");
        },
        onBackgroundMessage: myBackgroundMessageHandler);
    //hàm onLaunch và onResume được gọi khi data mà thông báo gửi về có kèm theo "click_action: FLUTTER_NOTIFICATION_CLICK"
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    return message['data'] = true;
  }
  //! end _TasksPageState
}
