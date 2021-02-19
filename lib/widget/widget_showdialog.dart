import 'package:flutter/material.dart';
import 'package:todo_app/models/login_models.dart';

class ShowDialogWidget {
  // static showDialogloading(context, String title) {
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       child: Dialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //         child: Container(
  //           height: MediaQuery.of(context).size.height * 0.1,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [CircularProgressIndicator(), Text(title)],
  //           ),
  //         ),
  //       ));
  // }

  static showDialogResuld(context, String title, String content) {
    return showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Text(title)),
      ),
    );
  }

  static showDiaLogResetPassword(context, TextEditingController email) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Đổi mật khẩu mới'),
          content: TextFormField(
            controller: email,
            decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(Icons.email),
              // border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Gửi Tới Email'),
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
