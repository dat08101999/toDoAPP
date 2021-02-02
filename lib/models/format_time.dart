import 'package:flutter/material.dart';

class FormatTimer {
  //* format lại định dạng ngày / tháng / năm
  static String dateTimeToString(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  //* reset giờ của 'dateTime' và thêm giờ,phút của 'time'
  static DateTime setDateTime(TimeOfDay time, DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day)
        .add(Duration(hours: time.hour, minutes: time.minute));
  }

  //* check thời gian người dùng chọn khi tạo lịch
  static bool checkTime(DateTime dateTime, TimeOfDay timeOfDay) {
    if (dateTime.day == DateTime.now().day) {
      print('1');
      if (timeOfDay.hour < TimeOfDay.now().hour) {
        print('2');
        return false;
      }
    }
    print('0');
    return true;
  }
}
