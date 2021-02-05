import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_add_page.dart';
import 'package:todo_app/controller/controller_home.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/format_time.dart';
import 'package:todo_app/screen/home_page.dart';

import 'login_models.dart';

class CRUDTask {
  var _controllerAddNew = Get.put(ControllerAddNew());
  final BuildContext context;

  CRUDTask({this.context});

  Future<void> addNewTask(String name, String description) async {
    _controllerAddNew.errorTextName = null;
    if (name == '' || name == null) {
      _controllerAddNew.errorTextName = 'Chưa nhập tên công việc';
      return null;
    }
    if (FormatTimer.checkTime(
        _controllerAddNew.dateTime, _controllerAddNew.timeOfDay)) {
      var taskID = UniqueKey();
      var data = {
        'create_at': DateTime.now(),
        'description':
            description != null ? description : 'Không có mô tả công việc',
        'icon': _controllerAddNew.indexIconSelected,
        'name': name,
        'status': 'wait',
        'userid': LoginModels().getUser().uid,
        'expired_at': FormatTimer.setDateTime(
            _controllerAddNew.timeOfDay, _controllerAddNew.dateTime)
      };

      Flushbar(
          icon: Icon(
            CupertinoIcons.check_mark_circled,
            size: 28.0,
            color: Colors.green[300],
          ),
          backgroundColor: Colors.black54,
          title: 'Thành Công',
          message:
              '${FormatTimer.setDateTime(_controllerAddNew.timeOfDay, _controllerAddNew.dateTime)} sẽ nhận dc thông báo',
          duration: Duration(seconds: 2))
        ..show(context);

      BackgroundWorkManager.regisOneTime(
          taskID.toString(),
          taskID.toString(),
          getSeconds(Timestamp.fromDate(data['expired_at']), Timestamp.now()),
          data);

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskID.toString())
          .set(data);
      await Future.delayed(Duration(seconds: 2));
      Get.offAll(HomePage());
    } else {
      Flushbar(
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red[300],
          ),
          backgroundColor: Colors.black54,
          title: 'Quá hạn',
          message: 'Không thể tạo lịch cho những giờ trước trong ngày',
          duration: Duration(seconds: 2))
        ..show(context);
    }
  }

  Future<void> updateTask(String name, String description, var task) async {
    _controllerAddNew.errorTextName = null;
    if (name == '' || name == null) {
      _controllerAddNew.errorTextName = 'Chưa nhập tên công việc';
      return null;
    }
    if (FormatTimer.checkTime(
        _controllerAddNew.dateTime, _controllerAddNew.timeOfDay)) {
      BackgroundWorkManager.cancelTask(uniqueName: task.id);

      var data = {
        'create_at': DateTime.now(),
        'description': description != null ? description : '',
        'icon': _controllerAddNew.indexIconSelected,
        'name': name != null ? name : 'todo something',
        'status': 'wait',
        'userid': LoginModels().getUser().uid,
        'expired_at': FormatTimer.setDateTime(
            _controllerAddNew.timeOfDay, _controllerAddNew.dateTime)
      };

      Flushbar(
          icon: Icon(
            CupertinoIcons.check_mark_circled,
            size: 28.0,
            color: Colors.green[300],
          ),
          backgroundColor: Colors.black54,
          title: 'Thành Công',
          message:
              '${FormatTimer.setDateTime(_controllerAddNew.timeOfDay, _controllerAddNew.dateTime)} sẽ nhận dc thông báo',
          duration: Duration(seconds: 2))
        ..show(context);

      BackgroundWorkManager.regisOneTime(
          task.id,
          task.id,
          getSeconds(Timestamp.fromDate(data['expired_at']), Timestamp.now()),
          data);

      FirebaseFirestore.instance.collection('tasks').doc(task.id).update(data);
      await Future.delayed(Duration(seconds: 2));
      Get.offAll(HomePage());
    } else {
      Flushbar(
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red[300],
          ),
          backgroundColor: Colors.black54,
          title: 'Quá hạn',
          message: 'Không thể tạo lịch cho những giờ trước trong ngày',
          duration: Duration(seconds: 2))
        ..show(context);
    }
  }

  static Future<void> deleteTask(QueryDocumentSnapshot task) async {
    await FirebaseFirestore.instance.collection('tasks').doc(task.id).delete();
  }

  static Future<void> deleteTaskList(QueryDocumentSnapshot taskdelete) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .where('userid', isEqualTo: LoginModels().getUser().uid)
        .orderBy('expired_at', descending: false)
        .get()
        .then((tasks) => {
              tasks.docs.forEach((task) {
                if (task['name'] == taskdelete['name'] &&
                    task['description'] == taskdelete['description'] &&
                    task['create_at'].toDate().hour ==
                        task['create_at'].toDate().hour &&
                    task['create_at'].toDate().minute ==
                        taskdelete['create_at'].toDate().minute) {
                  deleteTask(task);
                }
              })
            });
  }

  Future<void> loopTaskTheWeekly(var task) async {
    if (task != null) {
      var month = Get.find<ControllerHome>().currentMonth;
      var year = Get.find<ControllerHome>().currentYear;
      var day = Get.find<ControllerHome>().currentDay;
      for (int i = 1; i < 12; i++) {
        month = month + 1;
        if (month > 12) {
          year = year + 1;
          month = 1;
          var taskID = UniqueKey();
          var data = {
            'create_at': DateTime.now(),
            'description':
                task['description'] != null ? task['description'] : '',
            'icon': task['icon'],
            'name': task['name'] != null ? task['name'] : 'todo something',
            'status': 'wait',
            'type': 'weekly',
            'userid': LoginModels().getUser().uid,
            'expired_at': FormatTimer.setDateTime(
                TimeOfDay.fromDateTime(task['expired_at'].toDate()),
                DateTime(year, month, day))
          };
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskID.toString())
              .set(data);
          print("đã đăng kí tháng " + DateTime(year, month, day).toString());
        } else {
          print("đã đăng kí tháng " + DateTime(year, month, day).toString());
          var taskID = UniqueKey();
          var data = {
            'create_at': DateTime.now(),
            'description':
                task['description'] != null ? task['description'] : '',
            'icon': task['icon'],
            'name': task['name'] != null ? task['name'] : 'todo something',
            'status': 'wait',
            'type': 'weekly',
            'userid': LoginModels().getUser().uid,
            'expired_at': FormatTimer.setDateTime(
                TimeOfDay.fromDateTime(task['expired_at'].toDate()),
                DateTime(year, month, day))
          };
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskID.toString())
              .set(data);
        }
      }
    } else {
      Flushbar(
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red[300],
          ),
          backgroundColor: Colors.black54,
          title: 'Quá hạn',
          message: 'Không thể tạo lịch cho những giờ trước trong ngày',
          duration: Duration(seconds: 2))
        ..show(context);
    }
  }

  // void monthLy() async {
  //   for (int i = 1; i < 12; i++) {
  //     month = month + 1;
  //     if (month > 12) {
  //       year = year + 1;
  //       month = 1;
  //       print("đã đăng kí tháng " + DateTime(year, month, day).toString());
  //     } else {
  //       print("đã đăng kí tháng " + DateTime(year, month, day).toString());
  //     }
  //   }
}
