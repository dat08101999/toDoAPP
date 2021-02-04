import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_add_page.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/format_time.dart';

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

      print(
          '${getSeconds(Timestamp.fromDate(data['expired_at']), Timestamp.now())}');

      BackgroundWorkManager.regisOneTime(
          taskID.toString(),
          taskID.toString(),
          getSeconds(Timestamp.fromDate(data['expired_at']), Timestamp.now()),
          data);

      FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskID.toString())
          .set(data);
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
}
