import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void backgroundtask() {
  Workmanager.executeTask(
      (String taskName, Map<String, dynamic> inputData) async {
    await Firebase.initializeApp();
    switch (taskName) {
      case 'asyncTask':
        await asyncTasks();
        break;
      default:
        BackgroundWorkManager.onNoticfication(
            title: inputData['name'],
            body:
                '${inputData['description']}  ! chạm vào thông báo để xác nhận đã hoàn thành !',
            payload: taskName);
        var data = {'status': 'miss'};
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskName)
            .update(data);
        break;
    }
    return Future.value(true);
  });
}

class BackgroundWorkManager {
  static var flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initNotification() async {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: (payload) async {
      print('onSelectNotification :$payload');
      var data = {'status': 'done'};
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(payload)
          .update(data);
    });
  }

  ///* Show thông báo
  static void onNoticfication(
      {String title, String body, String payload}) async {
    var notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('id', 'thong_bao', 'description',
            importance: Importance.max),
        iOS: IOSNotificationDetails());
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  ///* Xoá bỏ lịch của Task
  static cancelTask({@required String uniqueName}) async {
    await Workmanager.cancelByUniqueName(uniqueName);
  }

  ///* Hàm đặt lịch thông báo,seconds = khoảng thời gian từ now đến lúc thực hiện thông báo
  static regisOneTime(
      uniqueName, idTask, seconds, Map<String, dynamic> data) async {
    await Workmanager.registerOneOffTask(uniqueName, idTask,
        inputData: taskToMap(data), initialDelay: Duration(seconds: seconds));
  }

  ///* Hàm đăng kí task chạy nền 15 phút tự khởi tạo 1 lần
  static regisMultiTask() async {
    await Workmanager.registerPeriodicTask('registerPeriodicTask', 'asyncTask',
        inputData: {'data': 'this registerPeriodicTask'},
        frequency: Duration(minutes: 5),
        initialDelay: Duration(seconds: 10));
  }
}

int getSeconds(Timestamp end, Timestamp now) {
  return end.seconds - now.seconds;
}

///* Chuyển đổi toàn bộ dữ liệu task thành String
Map<String, dynamic> taskToMap(Map<String, dynamic> data) {
  return {
    'name': data['name'],
    'create_at': data['create_at'].toString(),
    'description': data['description'],
    'status': data['status'],
    'userid': data['userid'],
    'icon': data['icon'],
    'expired_at': data['expired_at'].toString(),
  };
}

Future<void> asyncTasks() async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .where('userid', isEqualTo: 'T7g1RTorhdbGkEozJGjcAuAbmFs1')
      .orderBy('expired_at', descending: false)
      .get()
      .then(
        (tasks) => {
          tasks.docs.forEach(
            (task) {
              if (task['status'] == 'wait' &&
                  getSeconds(task['expired_at'], Timestamp.now()) > 1) {
                print(task['name']);
                BackgroundWorkManager.regisOneTime(
                    '${task['name']}-${task['expired_at'].toDate()}',
                    task.id,
                    getSeconds(task['expired_at'], Timestamp.now()),
                    task.data());
              }
            },
          ),
        },
      );
}
