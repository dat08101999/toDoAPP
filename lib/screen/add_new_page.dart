import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/config.dart';
import 'package:todo_app/controller/controller_add_page.dart';
import 'package:todo_app/models/crud_task.dart';
import 'package:todo_app/models/format_time.dart';
import 'package:todo_app/widget/widget_build_buttons.dart';

// ignore: must_be_immutable
class AddNewPage extends StatefulWidget {
  QueryDocumentSnapshot task;
  AddNewPage({this.task});
  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  ControllerAddNew _controllerAddNew;
  final controllerName = TextEditingController();
  final controllerDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerAddNew = Get.put(ControllerAddNew());
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: GetBuilder<ControllerAddNew>(builder: (ctl) {
              return InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///* Icon
                    Container(
                      height: 100,
                      margin: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('Icon', style: ConfigText.textStyle),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ConfigIcon.listIconTask.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    _controllerAddNew.indexIconSelected = index;
                                    _controllerAddNew.colorIconSelected =
                                        Colors.red;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                    width:
                                        (_controllerAddNew.colorIconSelected !=
                                                    null &&
                                                _controllerAddNew
                                                        .indexIconSelected ==
                                                    index)
                                            ? 65
                                            : 45,
                                    height:
                                        // (_controllerAddNew.colorIconSelected !=
                                        //             null &&
                                        //         _controllerAddNew
                                        //                 .indexIconSelected ==
                                        //             index)
                                        //     ? 55 :
                                        45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: (_controllerAddNew
                                                      .colorIconSelected !=
                                                  null &&
                                              _controllerAddNew
                                                      .indexIconSelected ==
                                                  index)
                                          ? LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                  _controllerAddNew
                                                      .colorIconSelected[200],
                                                  Colors.red[500]
                                                ])
                                          : ConfigColor.getGradient(index),
                                    ),
                                    child: Icon(ConfigIcon.listIconTask[index],
                                        // ConfigIcon.getIcon(index),
                                        color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    ///* Name
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Name', style: ConfigText.textStyle),
                          ),
                          TextField(
                            onTap: () {
                              _controllerAddNew.errorTextName = null;
                            },
                            controller: controllerName,
                            decoration: InputDecoration(
                              errorText: _controllerAddNew.errorTextName,
                              hintText: 'Nhập tên công việc ',
                            ),
                          )
                        ],
                      ),
                    ),

                    /// * description
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Description',
                                style: ConfigText.textStyle),
                          ),
                          TextField(
                            onTap: () {
                              _controllerAddNew.errorTextDescription = null;
                            },
                            controller: controllerDescription,
                            maxLines: 10,
                            decoration: InputDecoration(
                                errorText:
                                    _controllerAddNew.errorTextDescription,
                                hintText: 'Nhập nội dung công việc ',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Text('Timer', style: ConfigText.textStyle),
                        ],
                      ),
                    ),

                    ///* lịch và thời gian
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //* giờ
                          Row(
                            children: [
                              Text(_controllerAddNew.timeOfDay.hour.toString() +
                                  ':' +
                                  _controllerAddNew.timeOfDay.minute
                                      .toString()),
                              IconButton(
                                  icon: Icon(Icons.timer), onPressed: timePick),
                            ],
                          ),
                          // * ngày / tháng / năm
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: FormatTimer.dateTimeToString(
                                    _controllerAddNew.dateTime),
                                icon: Icon(CupertinoIcons.calendar),
                                iconSize: 24,
                                elevation: 16,
                                // style: TextStyle(color: Colors.deepPurple),
                                // underline: Container(
                                //   height: 2,
                                //   color: Colors.deepPurpleAccent,
                                // ),
                                onChanged: (String newValue) async {
                                  if (newValue == 'Chọn Ngày') {
                                    await datetimePick();
                                  }
                                },
                                items: <String>[
                                  FormatTimer.dateTimeToString(
                                      _controllerAddNew.dateTime),
                                  'Chọn Ngày'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: Get.height * 0.0507),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///* button Add
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                widget.task != null
                                    ? CRUDTask(context: context).updateTask(
                                        controllerName.text,
                                        controllerDescription.text,
                                        widget.task)
                                    : CRUDTask(context: context).addNewTask(
                                        controllerName.text,
                                        controllerDescription.text);
                              },
                              child: BuildWidget.buildContainerGradient(
                                  title:
                                      widget.task != null ? 'Update' : 'Add')),

                          ///* button Cancel
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: BuildWidget.buildContainerGradient(
                                  title: 'Cancel',
                                  color1: Colors.red,
                                  color2: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void initTask() {
    if (widget.task != null) {
      controllerName.text = widget.task['name'];
      controllerDescription.text = widget.task['description'];
      _controllerAddNew.indexIconSelected = widget.task['icon'];
      _controllerAddNew.timeOfDay =
          TimeOfDay.fromDateTime(widget.task['expired_at'].toDate());
      _controllerAddNew.dateTime = widget.task['expired_at'].toDate();
      _controllerAddNew.colorIconSelected = Colors.red;
    }
  }

  ///* show Dialog đồng hồ
  timePick() {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(data: ThemeData(), child: child);
        }).then((value) {
      if (value != null) _controllerAddNew.timeOfDay = value;
      print(_controllerAddNew.timeOfDay);
    });
  }

  ///* show Dialog lịch
  datetimePick() {
    showDatePicker(
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(3000),
        context: context,
        initialDate: DateTime.now(),
        builder: (context, child) {
          return Theme(data: ThemeData(), child: child);
        }).then((value) {
      if (value != null) _controllerAddNew.dateTime = value;
      print(_controllerAddNew.dateTime);
    });
  }
}
