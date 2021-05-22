import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class Pincode extends StatefulWidget {
  @override
  _PincodeState createState() => _PincodeState();
}

class _PincodeState extends State<Pincode> {
  double height, width;
  String pincode = "", formattedDate = "";
  DateTime selected_date = DateTime.now();
  Map<dynamic, dynamic> data;
  List<dynamic> list = [];
  String h1 = "";
  SharedPreferences prefs;
  bool age18 = true, age45 = true;
  int count = 0;
  bool alert = false;

  String get_url({@required String pincode, @required String date}) {
    return "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=${pincode}&date=${date}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selected_date,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != selected_date)
      setState(() async {
        selected_date = pickedDate;
        formattedDate = DateFormat('dd-MM-yyyy').format(selected_date);
        print("\n Date : ${formattedDate}");
        await prefs.setString("formattedDate", formattedDate);
      });
  }

  void get_data() async {
    String url = get_url(pincode: pincode, date: formattedDate);
    print("\n url : $url");
    http.Response res = await http.get(Uri.parse(url));
    print("\n\n res : ${res.body}");
    setState(() {
      data = jsonDecode(res.body);
      list = data["sessions"];
    });
    print("\n\n Data : $list");
  }

  Widget get_listview() {
    print(list == null);
    if (list == null || list.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No Data Availabe",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey),
          ),
        ),
      );
    } else {
      count = 0;
      return Expanded(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            List slot = list[i]["slots"];
            if (age18 && age45) {
              if (list[i]["available_capacity_dose1"] > 0) {
                count = count + 1;
                return Card(
                  color: Colors.white70,
                  child: SizedBox(
                    height: height * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Name
                          Text(
                            "${list[i]["name"]}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          //address
                          Text(
                            "${list[i]["address"]}",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          // fee
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                  color: Colors.green,
                                  child: Text(
                                    "${list[i]["fee_type"]}",
                                    style: TextStyle(
                                        fontSize: width * 0.05,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                              RaisedButton(
                                  color: Colors.redAccent,
                                  child: Text(
                                    "Age Limit: ${list[i]["min_age_limit"]}",
                                    style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                              RaisedButton(
                                  color: Colors.orange,
                                  child: Text(
                                    "${list[i]["vaccine"]}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // available
                          Row(
                            children: [
                              Text(
                                "Available : ",
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    color: Colors.black),
                              ),
                              RaisedButton(
                                  color: list[i]["available_capacity_dose1"] > 0
                                      ? Colors.green
                                      : Colors.red,
                                  child: Text(
                                    "${list[i]["available_capacity_dose1"] > 0 ? list[i]["available_capacity_dose1"] : "Booked"}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ],
                          ),
                          // Slot
                          Text(
                            "Slot : ",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: slot.length,
                                itemBuilder: (context, j) {
                                  return RaisedButton(
                                      color: Colors.blue,
                                      child: Text(
                                        "${slot[j]}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else if (age18) {
              if (list[i]["available_capacity_dose1"] > 0 &&
                  list[i]["min_age_limit"] == 18) {
                count = count + 1;
                return Card(
                  color: Colors.white70,
                  child: SizedBox(
                    height: height * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Name
                          Text(
                            "${list[i]["name"]}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          //address
                          Text(
                            "${list[i]["address"]}",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          // fee
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                  color: Colors.green,
                                  child: Text(
                                    "${list[i]["fee_type"]}",
                                    style: TextStyle(
                                        fontSize: width * 0.05,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                              RaisedButton(
                                  color: Colors.redAccent,
                                  child: Text(
                                    "Age Limit: ${list[i]["min_age_limit"]}",
                                    style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                              RaisedButton(
                                  color: Colors.orange,
                                  child: Text(
                                    "${list[i]["vaccine"]}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // available
                          Row(
                            children: [
                              Text(
                                "Available : ",
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    color: Colors.black),
                              ),
                              RaisedButton(
                                  color: list[i]["available_capacity_dose1"] > 0
                                      ? Colors.green
                                      : Colors.red,
                                  child: Text(
                                    "${list[i]["available_capacity_dose1"] > 0 ? list[i]["available_capacity_dose1"] : "Booked"}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ],
                          ),
                          // Slot
                          Text(
                            "Slot : ",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: slot.length,
                                itemBuilder: (context, j) {
                                  return RaisedButton(
                                      color: Colors.blue,
                                      child: Text(
                                        "${slot[j]}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else if (age45) {
              if (list[i]["available_capacity_dose1"] > 0 &&
                  list[i]["min_age_limit"] == 45) {
                count = count + 1;
                return Card(
                  color: Colors.white70,
                  child: SizedBox(
                    height: height * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Name
                          Text(
                            "${list[i]["name"]}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          //address
                          Text(
                            "${list[i]["address"]}",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          // fee
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                  color: Colors.green,
                                  child: Text(
                                    "${list[i]["fee_type"]}",
                                    style: TextStyle(
                                        fontSize: width * 0.05,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                              RaisedButton(
                                  color: Colors.redAccent,
                                  child: Text(
                                    "Age Limit: ${list[i]["min_age_limit"]}",
                                    style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                              RaisedButton(
                                  color: Colors.orange,
                                  child: Text(
                                    "${list[i]["vaccine"]}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // available
                          Row(
                            children: [
                              Text(
                                "Available : ",
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    color: Colors.black),
                              ),
                              RaisedButton(
                                  color: list[i]["available_capacity_dose1"] > 0
                                      ? Colors.green
                                      : Colors.red,
                                  child: Text(
                                    "${list[i]["available_capacity_dose1"] > 0 ? list[i]["available_capacity_dose1"] : "Booked"}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ],
                          ),
                          // Slot
                          Text(
                            "Slot : ",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: slot.length,
                                itemBuilder: (context, j) {
                                  return RaisedButton(
                                      color: Colors.blue,
                                      child: Text(
                                        "${slot[j]}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else {
              count = count + 1;
              return Card(
                color: Colors.white70,
                child: SizedBox(
                  height: height * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Name
                        Text(
                          "${list[i]["name"]}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //address
                        Text(
                          "${list[i]["address"]}",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        // fee
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  "${list[i]["fee_type"]}",
                                  style: TextStyle(
                                      fontSize: width * 0.05,
                                      color: Colors.white),
                                ),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                            RaisedButton(
                                color: Colors.redAccent,
                                child: Text(
                                  "Age Limit: ${list[i]["min_age_limit"]}",
                                  style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                            RaisedButton(
                                color: Colors.orange,
                                child: Text(
                                  "${list[i]["vaccine"]}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // available
                        Row(
                          children: [
                            Text(
                              "Available : ",
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),
                            ),
                            RaisedButton(
                                color: list[i]["available_capacity_dose1"] > 0
                                    ? Colors.green
                                    : Colors.red,
                                child: Text(
                                  "${list[i]["available_capacity_dose1"] > 0 ? list[i]["available_capacity_dose1"] : "Booked"}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                          ],
                        ),
                        // Slot
                        Text(
                          "Slot : ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: slot.length,
                              itemBuilder: (context, j) {
                                return RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      "${slot[j]}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)));
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
    }
  }

  Widget get_list() {
    Widget W = get_listview();
    return W;
  }

  void get_instnace() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("age18") == null) {
      await prefs.setBool("age18", false);
      age18 = false;
    } else {
      age18 = prefs.getBool("age18");
    }
    if (prefs.getBool("age45") == null) {
      await prefs.setBool("age45", false);
      age18 = false;
    } else {
      age18 = prefs.getBool("age45");
    }
    //formate date
    if (prefs.getString("formattedDate") != null) {
      setState(() {
        formattedDate = prefs.getString("formattedDate");
      });
    }
    //pinecode
    if (prefs.getString("pincode") != null) {
      pincode = prefs.getString("pincode");
    }
    print("\n\n\ age45 : $age45");
  }

  void repeat() {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      setState(() {
        count;
        print("Counter $count");
        get_data();
      });
      if (count > 0 && alert) {
        print("Count : $count");
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("\n\n start instance");
    get_instnace();
    repeat();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Vaccine Alert"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                alert = !alert;
              });
            },
            icon: Icon(Icons.add_alert),
            color: alert ? Colors.red : Colors.white,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06, vertical: height * 0.02),
              child: RaisedButton(
                color: Colors.lightBlueAccent,
                onPressed: () => _selectDate(context),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      '  Select date',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Selected Date : ${formattedDate}',
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: TextFormField(
                onChanged: (text) async {
                  setState(() async {
                    pincode = text;
                    await prefs.setString("pincode", pincode);
                    if (formattedDate.isEmpty) {
                      h1 = "please select a date";
                    }
                    if (pincode.isEmpty) {
                      h1 = "please Enter a pincode";
                    }
                    if (formattedDate.isNotEmpty && pincode.isNotEmpty) {
                      h1 = "";
                    }
                    if (pincode.length == 6) {
                      print("ok");
                      get_data();
                    }
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Pincode',
                  helperText: h1,
                  helperStyle: TextStyle(color: Colors.red),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    color: age18 ? Colors.green : Colors.grey,
                    child: Text(
                      "Show 18+",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        prefs.setBool("age18", !age18);
                        age18 = !age18;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0))),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () async {
                    get_data();
                    setState(() {
                      count = 0;
                    });
                  },
                  child: Text(
                    "Check",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                RaisedButton(
                    color: age45 ? Colors.orange : Colors.grey,
                    child: Text(
                      "Show 45+",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        print(!age45);
                        prefs.setBool("age45", !age45);
                        age45 = !age45;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)))
              ],
            ),
            get_list(),
          ],
        ),
      ),
    );
  }
}
