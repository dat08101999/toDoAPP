import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CheckBoxTaskController extends GetxController {
  static List<QueryDocumentSnapshot> listTask = List<QueryDocumentSnapshot>();
  bool chekboxIsHide = true;
  isTapOn() {
    update();
  }

  changStateCheckBoxArea() {
    chekboxIsHide = !chekboxIsHide;
    update();
  }
}
