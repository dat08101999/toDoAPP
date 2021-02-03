import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/config/config.dart';
import 'package:todo_app/models/crud_task.dart';

class ViewInfoTask extends StatelessWidget {
  QueryDocumentSnapshot task;
  ViewInfoTask({this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                CRUDTask.deleteTask(task);
              })
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Name
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name :', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(task['name'],
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  ),
                ],
              ),
            ),

            //* Description
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description:', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        task['description'] != ''
                            ? task['description']
                            : 'Bỏ Trống',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  ),
                ],
              ),
            ),

            //* Create_at
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create At:', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${task['create_at'].toDate()}',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  ),
                ],
              ),
            ),

            //* Expired_at
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expired At:', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${task['expired_at'].toDate()}',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status :', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${task['status']}',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
