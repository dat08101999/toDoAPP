import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/crud_task.dart';

class MenuLoop extends StatelessWidget {
  QueryDocumentSnapshot task;
  MenuLoop({this.task});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: Get.height * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Text('Lặp Lại Hàng Ngày',
                  style: TextStyle(decoration: TextDecoration.underline)),
            ),
            InkWell(
              onTap: () {
                CRUDTask().loopTaskTheWeekly(task);
              },
              child: Text('Lặp Lại Hàng Tháng'),
            ),
            InkWell(
              onTap: () {},
              child: Text('Lặp Lại Hàng Năm'),
            ),
          ],
        ),
      ),
    );
  }
}
