import 'package:flutter/material.dart';
import 'package:todo_app/models/login_models.dart';

class ShowDialogWidget {
  static showDialogloading(context, String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
          title: Container(
            child: Column(
              children: [CircularProgressIndicator(), Text(title)],
            ),
          ),
        ));
  }

  static showDialogResuld(context, String title, String content) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
        ));
  }

  static showDiaLogResetPassword(context, TextEditingController email) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Reset password'),
          content: TextFormField(
            controller: email,
            decoration:
                InputDecoration(hintText: 'email', icon: Icon(Icons.email)),
          ),
          actions: [
            FlatButton(
              child: Text('Gửi email reset password'),
              onPressed: () async {
                if (email.text != '') {
                  await LoginModels().sendPasswordResetRequest(email.text);
                  showDialogResuld(
                      context,
                      LoginModels.error != ''
                          ? LoginModels.error
                          : 'Đã gửi yêu cầu reset password',
                      '');
                  return;
                }
                showDialogResuld(context, 'Vui lòng nhập email của bạn', '');
              },
            )
          ],
        ));
  }

  static showDialogAcept(
      context, String title, String buttonconten, Function() acceptPress) {
    return showDialog(
        context: context,
        child: AlertDialog(
            title: Text(title),
            content: FlatButton(
              child: Text(buttonconten),
              onPressed: () {
                acceptPress();
              },
            )));
  }
}
