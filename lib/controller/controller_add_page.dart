import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerAddNew extends GetxController {
  int _indexIconSelected = 0;
  MaterialColor _colorIconSelected;
  TimeOfDay _timeOfDay = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();
  String _errorTextDescription;
  String _errorTextName;

  List<IconData> listIconTask = [
    Icons.notifications,
    Icons.shopping_bag,
    CupertinoIcons.location,
    Icons.party_mode,
    Icons.watch_outlined,
    Icons.ballot,
    CupertinoIcons.checkmark_alt_circle_fill,
    CupertinoIcons.check_mark_circled_solid
  ];

  IconData getItemIconTask(int index) {
    return listIconTask[index];
  }

  String get errorTextName => _errorTextName;

  set errorTextName(String errorTextName) {
    _errorTextName = errorTextName;
    update();
  }

  String get errorTextDescription => _errorTextDescription;

  set errorTextDescription(String errorTextDescription) {
    _errorTextDescription = errorTextDescription;
    update();
  }

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;
    update();
  }

  TimeOfDay get timeOfDay => _timeOfDay;

  set timeOfDay(TimeOfDay timeOfDay) {
    _timeOfDay = timeOfDay;
    update();
  }

  MaterialColor get colorIconSelected => _colorIconSelected;

  set colorIconSelected(Color colorIconSelected) {
    _colorIconSelected = colorIconSelected;
    update();
  }

  int get indexIconSelected => _indexIconSelected;

  set indexIconSelected(int indexIconSelected) {
    _indexIconSelected = indexIconSelected;
    update();
  }
}
