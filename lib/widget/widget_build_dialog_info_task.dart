import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/config.dart';

// ignore: must_be_immutable
class ShowDialogInfo extends StatelessWidget {
  QueryDocumentSnapshot task;
  ShowDialogInfo({this.task});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: Get.height * 0.4,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.grey.withOpacity(0.2)),
              child: Column(
                children: [
                  //*Icon
                  Container(
                    height: Get.height * 0.0507,
                    width: Get.height * 0.0507,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: ConfigColor.getGradient(task['icon']),
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      ConfigIcon.getIcon(task['icon']),
                      size: Get.height * 0.0310,
                      color: Colors.white70,
                    ),
                  ),
                  //* Name
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      task['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  //* Time
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${task['expired_at'].toDate()}',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  )
                ],
              ),
            ),
            //* description
            Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(10),
                //     bottomRight: Radius.circular(10))
              ),
              child: Column(
                children: [
                  Text('Description:', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        task['description'] != ''
                            ? task['description']
                            : 'Bỏ Trống',
                        maxLines: 10,
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
