import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/crud_task.dart';
import 'package:todo_app/models/loading.dart';
import 'package:todo_app/widget/widget_build_flushbar.dart';

// ignore: must_be_immutable
class MenuLoopDelete extends StatelessWidget {
  QueryDocumentSnapshot task;
  MenuLoopDelete({this.task});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        height: Get.height * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                Navigator.pop(context);
                Loading.show();
                await CRUDTask.deleteTaskList(task);
                Loading.dismiss();
                ShowFlushbar.showSuccecs(
                    message: 'Đã xóa lịch này trong các lần sau');
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  child: Text('Xoá Cả Những Lần Sau')),
            ),
            InkWell(
              onTap: () async {
                BackgroundWorkManager.cancelTask(uniqueName: task.id);
                CRUDTask.deleteTask(task);
                Navigator.pop(context);
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  child: Text('Chỉ Xóa Hôm Nay')),
            ),
          ],
        ),
      ),
    );
  }
}
