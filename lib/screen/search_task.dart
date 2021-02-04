import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/login_models.dart';
import 'package:todo_app/widget/widget_build_task_item.dart';
import 'package:todo_app/widget/widget_build_task_search.dart';

class SearchTask extends StatefulWidget {
  @override
  _SearchTaskState createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  Query taskSearch = FirebaseFirestore.instance
      .collection('tasks')
      .where('userid', isEqualTo: LoginModels().getUser().uid);
  // .where('name', isEqualTo: text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  hintText: 'Nhập tên việc cần tìm !',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (text) async {
                if (text != '') {
                  taskSearch = FirebaseFirestore.instance
                      .collection('tasks')
                      .where('userid', isEqualTo: LoginModels().getUser().uid)
                      .where('name', isGreaterThanOrEqualTo: text)
                      .where('name', isLessThanOrEqualTo: text + '\uf8ff');
                } else {
                  taskSearch = FirebaseFirestore.instance
                      .collection('tasks')
                      .where('userid', isEqualTo: LoginModels().getUser().uid);
                }
                setState(() {});
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: taskSearch.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Opps ! có lỗi gì đó'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return BuildTaskSearch(task: snapshot.data.docs[index]);
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
