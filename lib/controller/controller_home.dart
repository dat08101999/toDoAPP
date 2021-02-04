import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerHome extends GetxController {
  List<DateTime> _listday = [];
  int _currentDay = DateTime.now().day;
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;
  bool _actionActive = false;
  int _indexpage = 0;
  PageController pageController =
      PageController(initialPage: DateTime.now().day, viewportFraction: 0.2);

  int get indexpage => _indexpage;

  set indexpage(int indexpage) {
    _indexpage = indexpage;
    update();
  }

  bool get actionActive => _actionActive;

  set actionActive(bool actionActive) {
    _actionActive = actionActive;
    update();
  }

  int get currentMonth => _currentMonth;

  set currentMonth(int currentMonth) {
    _currentMonth = currentMonth;
    update();
  }

  int get currentYear => _currentYear;

  set currentYear(int currentYear) {
    _currentYear = currentYear;
    update();
  }

  int get currentDay => _currentDay;

  set currentDay(int currentDay) {
    _currentDay = currentDay;
    update();
  }

  List<DateTime> get listday => _listday;

  set listday(List<DateTime> listday) {
    _listday = listday;
    update();
  }

  void comeBackMothAlert() {
    if (_currentMonth > 1) {
      _currentMonth = _currentMonth - 1;
    } else {
      _currentMonth = 12;
      _currentYear = _currentYear - 1;
    }
    if (_currentMonth == DateTime.now().month)
      _currentDay = DateTime.now().day;
    else
      _currentDay = 1;
    initListDay();
    update();
  }

  void nextMothBefore() {
    if (_currentMonth != 12) {
      _currentMonth = _currentMonth + 1;
    } else {
      _currentMonth = 1;
      _currentYear = _currentYear + 1;
    }
    if (_currentMonth == DateTime.now().month)
      _currentDay = DateTime.now().day;
    else
      _currentDay = 1;
    initListDay();
    update();
  }

  initListDay() {
    _listday.clear();
    DateTime dateTime = DateTime.utc(_currentYear, _currentMonth + 1)
        .subtract(Duration(days: 1));
    for (int i = 1; i <= dateTime.day; i++) {
      var date = DateTime.utc(_currentYear, _currentMonth, i);
      _listday.add(date);
    }
  }

  bool checkDate() {
    var howLog = Timestamp.fromDate(DateTime(_currentYear, _currentMonth,
                _currentDay, TimeOfDay.now().hour, TimeOfDay.now().minute))
            .seconds -
        Timestamp.now().seconds;
    if (howLog > -60) {
      return true;
    }
    return false;
  }
}
