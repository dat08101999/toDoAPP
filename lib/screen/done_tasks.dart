import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/login_models.dart';
import 'package:todo_app/widget/widget_build_task_done_item.dart';

class DoneTasks extends StatefulWidget {
  @override
  _DoneTasksState createState() => _DoneTasksState();
}

class _DoneTasksState extends State<DoneTasks> {
  Query listTasksDone;
  @override
  void initState() {
    super.initState();
    listTasksDone = FirebaseFirestore.instance
        .collection('tasks')
        .where('userid', isEqualTo: LoginModels().getUser().uid)
        // .where('status', isNotEqualTo: 'done')
        .orderBy('expired_at', descending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Done Tasks',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            child: StreamBuilder<QuerySnapshot>(
              stream: listTasksDone.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Opps ! có lỗi gì đó'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    if (snapshot.data.docs[index]['status'] != 'wait')
                      return BuildTaskDoneItem(task: snapshot.data.docs[index]);
                  },
                );
              },
            )),
      ),
    );
  }
}
