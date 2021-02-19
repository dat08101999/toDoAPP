import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_home.dart';

class ControllerAddNew extends GetxController {
  int _indexIconSelected = 0;
  MaterialColor _colorIconSelected;
  TimeOfDay _timeOfDay = TimeOfDay.now();
  DateTime _dateTime = DateTime.utc(
      Get.find<ControllerHome>().currentYear,
      Get.find<ControllerHome>().currentMonth,
      Get.find<ControllerHome>().currentDay);
  String _errorTextDescription;
  String _errorTextName;

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
