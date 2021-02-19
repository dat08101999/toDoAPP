import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/crud_task.dart';
import 'package:todo_app/models/loading.dart';
import 'package:todo_app/widget/widget_build_flushbar.dart';

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
                ShowFlushbar.showSuccecs(
                    message: 'Đã tạo lich cho những ngày sau');
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
                ShowFlushbar.showSuccecs(
                    message: 'Đã tạo lịch này trong các tháng sau');
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
                ShowFlushbar.showSuccecs(
                    message: 'Đã tạo lịch này trong các tuần sau');
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
