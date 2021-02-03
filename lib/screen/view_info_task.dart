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
          children: [
            //*Name
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name :', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(task['name'], style: ConfigText.textStyle),
                  ),
                ],
              ),
            ),

            //* Description
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description', style: ConfigText.textStyle),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        task['description'] != ''
                            ? task['description']
                            : 'Bỏ Trống',
                        style: ConfigText.textStyle),
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
