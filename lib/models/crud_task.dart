import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_add_page.dart';
import 'package:todo_app/models/LoginModels.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/format_time.dart';

class CRUDTask {
  var _controllerAddNew = Get.find<ControllerAddNew>();
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
      await Future.delayed(Duration(milliseconds: 500));
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
      _controllerAddNew.errorTextName =
          '${FormatTimer.setDateTime(_controllerAddNew.timeOfDay, _controllerAddNew.dateTime)} sẽ nhận dc thông báo';
      BackgroundWorkManager.regisOneTime(
          data['name'],
          getSeconds(Timestamp.fromDate(data['expired_at']), Timestamp.now()),
          data);
      FirebaseFirestore.instance.collection('tasks').add(data);
    } else {
      Flushbar(
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          backgroundColor: Colors.black54,
          title: 'Quá hạn',
          message: 'Không thể tạo lịch cho những giờ trước trong ngày',
          duration: Duration(seconds: 3))
        ..show(context);
    }
  }
}
