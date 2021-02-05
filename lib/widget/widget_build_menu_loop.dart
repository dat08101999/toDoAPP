import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/crud_task.dart';
import 'package:todo_app/models/loading.dart';

// ignore: must_be_immutable
class MenuLoop extends StatelessWidget {
  QueryDocumentSnapshot task;
  MenuLoop({this.task});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(10),
        height: Get.height * 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                Navigator.pop(context);
                Loading.show();
                await CRUDTask().loopTaskTheDay(task);
                Loading.dismiss();
                Flushbar(
                    icon: Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 28.0,
                      color: Colors.green[300],
                    ),
                    backgroundColor: Colors.black54,
                    title: 'Thành Công',
                    message: 'Đã tạo lịch này trong các tháng sau',
                    duration: Duration(seconds: 2))
                  ..show(navigatorKey.currentContext);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50,
                child: Text(
                  'Lặp Lại Hàng Ngày',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                Navigator.pop(context);
                Loading.show();
                await CRUDTask().loopTaskTheMonthly(task);
                Loading.dismiss();
                Flushbar(
                    icon: Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 28.0,
                      color: Colors.green[300],
                    ),
                    backgroundColor: Colors.black54,
                    title: 'Thành Công',
                    message: 'Đã tạo lịch này trong các tháng sau',
                    duration: Duration(seconds: 2))
                  ..show(navigatorKey.currentContext);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Lặp Lại Hàng Tháng',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                Navigator.pop(context);
                Loading.show();
                await CRUDTask().loopTaskTheWeekly(task);
                Loading.dismiss();
                Flushbar(
                    icon: Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 28.0,
                      color: Colors.green[300],
                    ),
                    backgroundColor: Colors.black54,
                    title: 'Thành Công',
                    message: 'Đã tạo lịch này trong các tháng sau',
                    duration: Duration(seconds: 2))
                  ..show(navigatorKey.currentContext);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Lặp Lại Hàng Tuần',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
