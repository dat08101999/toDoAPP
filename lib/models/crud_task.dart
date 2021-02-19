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
        'description': (description != null || description != '')
            ? description
            : 'Không có mô tả công việc',
        'icon': _controllerAddNew.indexIconSelected,
        'name': name,
        'status': 'wait',
        'type': 'none',
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
        'type': 'none',
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
                if (taskdelete['type'] == 'month') {
                  if (task['name'] == taskdelete['name'] &&
                      task['description'] == taskdelete['description'] &&
                      task['expired_at'].toDate().month <
                          taskdelete['expired_at'].toDate().month) {
                    var data = {'type': 'none'};
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(task.id)
                        .update(data);
                  }
                }
                if (taskdelete['type'] == 'daily') {
                  if (task['name'] == taskdelete['name'] &&
                      task['description'] == taskdelete['description'] &&
                      task['expired_at'].toDate().day <
                          taskdelete['expired_at'].toDate().day) {
                    var data = {'type': 'none'};
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(task.id)
                        .update(data);
                  }
                }
                if (taskdelete['type'] == 'weekly') {
                  if (task['name'] == taskdelete['name'] &&
                      task['description'] == taskdelete['description'] &&
                      task['expired_at'].toDate().day <
                          taskdelete['expired_at'].toDate().day &&
                      task['expired_at'].toDate().month <
                          taskdelete['expired_at'].toDate().month) {
                    var data = {'type': 'none'};
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(task.id)
                        .update(data);
                  }
                }
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

  Future<void> loopTaskTheMonthly(var task) async {
    if (task != null) {
      var data = {'type': 'month'};
      FirebaseFirestore.instance.collection('tasks').doc(task.id).update(data);
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
        } else {
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
    }
  }

  Future<void> loopTaskTheDay(var task) async {
    if (task != null) {
      var data = {'type': 'daily'};
      FirebaseFirestore.instance.collection('tasks').doc(task.id).update(data);
      var month = Get.find<ControllerHome>().currentMonth;
      var year = Get.find<ControllerHome>().currentYear;
      var day = Get.find<ControllerHome>().currentDay;
      for (int i = 1; i <= 10; i++) {
        DateTime lastDateofmonth =
            DateTime.utc(year, month + 1).subtract(Duration(days: 1));
        day += 1;
        if (day > lastDateofmonth.day) {
          day = 1;
          month = month + 1;
        }
        var taskID = UniqueKey();
        var data = {
          'create_at': DateTime.now(),
          'description': task['description'] != null ? task['description'] : '',
          'icon': task['icon'],
          'name': task['name'] != null ? task['name'] : 'todo something',
          'status': 'wait',
          'type': 'daily',
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
  }

  Future<void> loopTaskTheWeekly(var task) async {
    if (task != null) {
      var data = {'type': 'weekly'};
      FirebaseFirestore.instance.collection('tasks').doc(task.id).update(data);
      var month = Get.find<ControllerHome>().currentMonth;
      var year = Get.find<ControllerHome>().currentYear;
      var day = Get.find<ControllerHome>().currentDay;
      var weekday = DateTime(year, month, day).weekday;
      for (int i = 1; i < 92; i++) {
        DateTime lastDateofmonth =
            DateTime.utc(year, month + 1).subtract(Duration(days: 1));
        day += 1;
        if (day > lastDateofmonth.day) {
          day = 1;
          month = month + 1;
        }
        if (DateTime(year, month, day).weekday == weekday) {
          ///đăng kí weekly
          var taskID = UniqueKey();
          var data = {
            'create_at': DateTime.now(),
            'description':
                task['description'] != null ? task['description'] : '',
            'icon': task['icon'],
            'name': task['name'] != null ? task['name'] : 'todo something',
            'status': 'wait',
            'type': 'daily',
            'userid': LoginModels().getUser().uid,
            'expired_at': FormatTimer.setDateTime(
                TimeOfDay.fromDateTime(task['expired_at'].toDate()),
                DateTime(year, month, day))
          };
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskID.toString())
              .set(data);

          ///
        }
      }
    }
  }
}
