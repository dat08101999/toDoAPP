import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/config.dart';
import 'package:todo_app/controller/controller_home.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/screen/add_new_page.dart';
import 'package:todo_app/screen/done_tasks.dart';
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
  Query tasks;
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
        centerTitle: true,
        title: Text('TODO App'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[300],
        elevation: 0,
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.menu, color: Colors.white), onPressed: () {}),
        // ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: ConfigColor.getGradient(3),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: GetBuilder<ControllerHome>(builder: (ctl) {
            return Stack(
              children: [
                //* build tháng
                BuildReMoteMonth(),
                //* build ngày
                Container(
                    margin: EdgeInsets.only(top: Get.height * 0.0507),
                    child: BuildScrollDate()),
                //* build task
                Container(
                  margin: EdgeInsets.only(top: Get.height * 0.1725),
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
                            return BuildTaskItem(
                                task: snapshot.data.docs[index]);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addTasks();
        },
        tooltip: 'Thêm Công Việc Mới',
        icon: Icon(Icons.add),
        label: Text('Thêm Mới'),
        focusColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.assignment_turned_in_rounded),
              onPressed: () {
                Get.to(DoneTasks());
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                print('Search button pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                print('Favorite button pressed');
              },
            ),
          ],
        ),
      ),
    );
  }

  void addTasks() async {
    if (controllerHome.checkDate()) {
      Get.to(AddNewPage());
    } else {
      Flushbar(
          icon: Icon(
            Icons.info_outlined,
            size: 28.0,
            color: Colors.red[300],
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
              title: message['notification']['title'],
              body: message['notification']['body'],
              payload: 'Clicked');
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
