import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/crud_task.dart';

// ignore: must_be_immutable
class MenuLoopDelete extends StatelessWidget {
  QueryDocumentSnapshot task;
  MenuLoopDelete({this.task});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: Get.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                CRUDTask.deleteTaskList(task);
              },
              child: Text('Xoá Cả Những Ngày Sau'),
            ),
            InkWell(
              onTap: () {
                BackgroundWorkManager.cancelTask(uniqueName: task.id);
                CRUDTask.deleteTask(task);
              },
              child: Text('Chỉ Xóa Hôm Nay'),
            ),
          ],
        ),
      ),
    );
  }
}
