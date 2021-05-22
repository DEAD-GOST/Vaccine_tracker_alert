import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class Welcome extends StatelessWidget {
  @override
  double height, width;
  String url = "https://www.cowin.gov.in/";
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Center(child: Image.asset("images/img4.png")),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Text(
                            "Check the availibity of vaccine",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Goldman'),
                          ),
                          Container(
                            child: SizedBox(
                              height: height * 0.1,
                              child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  RotateAnimatedText(
                                    'Available',
                                    textStyle: TextStyle(
                                      fontSize: height * 0.05,
                                      fontFamily: "OffsettDemoItalic",
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  RotateAnimatedText(
                                    'Not Available',
                                    textStyle: TextStyle(
                                      fontSize: height * 0.04,
                                      fontFamily: "OffsettDemoItalic",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.1,
                          width: width * 0.5,
                          child: FloatingActionButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/pincode');
                              },
                              child: Text(
                                "By Pincode",
                                style: TextStyle(fontSize: height * 0.035),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: height * 0.1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          "First please register yourself In :",
                          style: TextStyle(
                              color: Colors.red, fontSize: height * 0.02),
                        ),
                        SelectableLinkify(
                          style: TextStyle(fontSize: height * 0.02),
                          text: "https://www.cowin.gov.in/",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
