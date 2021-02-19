import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

///Khai báo 'final _navigatorKey = GlobalKey<NavigatorState>()' tại main.dart.
///BuildContext get currentContext => _navigatorKey.currentContext;
///Tại hàm build MaterialApp thêm thuộc tính 'navigatorKey: _navigatorKey'.

class Loading {
  Timer _timer;
  static Loading _loadingShow;
  bool _isLoading = false;
  TextStyle _textStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black54);

  static Loading getIntance() {
    if (_loadingShow == null) {
      return _loadingShow = new Loading();
    }
    return _loadingShow;
  }

  ///* nameFunction phải ở dạng void hoặc Future <T>.
  static showAwait(
      {String newTitle = 'Đang Tải ...',
      @required Function nameFunction}) async {
    getIntance()._showloading(title: newTitle);
    await nameFunction();
    getIntance()._dismiss();
  }

  static show({String newTitle = 'Đang Tải ...'}) {
    if (!getIntance()._isLoading)
      return getIntance()._showloading(title: newTitle);
  }

  static dismiss() {
    if (getIntance()._isLoading) return getIntance()._dismiss();
  }

  void _showloading({@required String title}) {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _dismiss();
    });
    showDialog(
      context: currentContext,
      barrierDismissible: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: MediaQuery.of(currentContext).size.height * 0.1,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.grey.withOpacity(0.1),
              ),
              Text(
                title,
                style: _textStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
    _isLoading = true;
  }

  void _dismiss() {
    cancelTimer();
    Navigator.pop(currentContext);
    _isLoading = false;
  }

  void cancelTimer() {
    this._timer?.cancel();
    this._timer = null;
  }
}
