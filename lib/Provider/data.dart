import 'package:flutter/material.dart';

class Data extends ChangeNotifier {
  String uid = "", name = "", phno = "";
//////////////////////Funtion Start
  set_data({String d_uid, String d_name, String d_phno, int d_location_index}) {
    if (d_uid != null) {
      uid = d_uid;
    }
    if (d_name != null) {
      name = d_name;
    }
    if (d_phno != null) {
      phno = d_phno;
    }
    notifyListeners();
  }

//////////////////////Funtion End
}
