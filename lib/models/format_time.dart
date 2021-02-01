import 'package:flutter/material.dart';

class FormatTimer {
  //* format lại định dạng ngày / tháng / năm
  static String dateTimeToString(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  //* tính toán để sắp xếp tạo lịch
  static DateTime setDateTime(TimeOfDay time, DateTime dateTime) {
    if (dateTime.day == DateTime.now().day) {
      return dateTime.add(Duration(
          hours: time.hour - TimeOfDay.now().hour,
          minutes: time.minute - TimeOfDay.now().minute));
    } else {
      return dateTime.add(Duration(
          hours: TimeOfDay.now().hour, minutes: TimeOfDay.now().minute));
    }
  }

  //* check thời gian người dùng chọn khi tạo lịch
  static bool checkTime(DateTime dateTime, TimeOfDay timeOfDay) {
    if (dateTime.day == DateTime.now().day) {
      if (timeOfDay.hour < TimeOfDay.now().hour) {
        return false;
      }
      if (timeOfDay.minute < TimeOfDay.now().minute) {
        return false;
      }
    }
    return true;
  }
}
