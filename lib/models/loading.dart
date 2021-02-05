import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

///Khai báo 'final navigatorKey = GlobalKey<NavigatorState>()' tại main.dart.
///Tại hàm build MaterialApp thêm thuộc tính 'navigatorKey: navigatorKey'.

class Loading {
  static Timer _timeout;
  static Loading _instance;
  static bool _isLoading = false;

  static _getInstance() {
    if (_instance == null) {
      return _instance = new Loading();
    }
    return _instance;
  }

  /// show dialog dạng loading với [tite] , [widget]
  static show({String title, Widget child}) async {
    await _getInstance()._show(title: title, child: child);
  }

  /// hủy bỏ dialog loading
  static dismiss({String title}) async {
    await _getInstance()._dismiss();
    if (title != null) {
      _getInstance()._showToast(status: title);
    }
  }

  static showErros({String status}) {
    _getInstance()._showToast(status: status);
  }

  // ignore: unused_element
  Future<void> _show({String title, Widget child}) {
    if (!_isLoading) {
      _timeout = Timer.periodic(Duration(minutes: 1), (timer) async {
        await _dismiss();
        _showToast();
        _cancelTimer();
      });
      _isLoading = true;
      return showDialog<void>(
        context: navigatorKey.currentContext,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: child != null
                ? child
                : Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text(title != null ? title : 'Please await...',
                            style: _style),
                      ],
                    ),
                  ),
          );
        },
      );
    } else {
      return null;
    }
  }

  Future<void> _dismiss() {
    if (_isLoading) {
      _cancelTimer();
      Navigator.of(navigatorKey.currentContext).pop();
      _isLoading = false;
    }
    return null;
  }

  static const TextStyle _style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);

  void _cancelTimer() {
    if (_timeout != null) {
      _timeout?.cancel();
      _timeout = null;
    }
  }

  Future<void> _showToast({String status}) {
    Timer.periodic(Duration(seconds: 2), (timer) {
      Navigator.of(navigatorKey.currentContext).pop();
      timer?.cancel();
    });
    return showDialog(
      barrierColor: Colors.transparent,
      context: navigatorKey.currentContext,
      barrierDismissible: false,
      builder: (context) => Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              status != null ? status : 'Timeout , request failed !',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _style,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ).then((value) => print('_showToast then'));
  }
}
