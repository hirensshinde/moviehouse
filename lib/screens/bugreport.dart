import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/screens/successScreen.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class BugReport extends StatefulWidget {
  final String apiKey;
  BuildContext pageContext;

  BugReport({this.apiKey, this.pageContext});

  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  TextEditingController textController = TextEditingController();

  String report;
  BuildContext dialogContext;

  Future reportBug() async {
    print(report);
    http.Response response = await http.get(Uri.parse(
        'https://api.moviehouse.download/api/feedback?api_key=${widget.apiKey}&message=$report'));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['message']);
    }
  }

  // bool _keyboardIsVisible() {
  //   var currentScreenSize = getSafeAreaSize(MediaQuery.of(context));
  //   return widget.sizeOfParentWidget.height < currentScreenSize.height;
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        // drawer: NavigationDrawerWidget(),
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Tell me our Bug',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "NEXA",
                  fontWeight: FontWeight.bold)),
          leading: Builder(
              builder: (context) => IconButton(
                    splashRadius: 30.0,
                    padding: EdgeInsets.all(0.0),
                    icon: SvgPicture.asset(
                      'assets/icons/Back.svg',
                      height: 35.0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: !showFab
        //     ? FloatingActionButton.extended(
        //         label: Text('Submit Request',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 18.0,
        //               fontFamily: "NEXA",
        //             )),
        //         onPressed: () {

        //         },
        //       )
        //     : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.0),
                width: size.width * .7,
                height: size.height * .4,
                alignment: Alignment.center,
                child: SvgPicture.asset('assets/images/bugreport.svg'),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Tell me",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.white)),
                      TextSpan(
                          text: " OUR BUG ",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "and \n issues you are facing now",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                color: Colors.white,
                                fontFamily: "NEXA",
                              )),
                    ]),
                  )),
              Text(
                "We will resolve it within 72 hrs.",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Color.fromARGB(255, 2, 198, 151),
                    fontFamily: "NEXA",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Container(
                  width: size.width * 0.9,
                  height: 120.0,
                  // margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color.fromARGB(255, 25, 27, 45),
                  ),
                  child: TextField(
                    controller: textController,
                    onChanged: (String value) async {
                      print(MediaQuery.of(context).size.height);
                      if (value.isNotEmpty) {
                        setState(() {
                          report = value;
                        });
                      }
                    },
                    onSubmitted: (String value) async {
                      print(MediaQuery.of(context).size.height);

                      if (value.isNotEmpty) {
                        setState(() {
                          report = value;
                        });
                      }
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      focusedBorder: InputBorder.none,
                      hintText: "Tell me our bugs and issues...",
                      hintStyle: TextStyle(
                        color: Colors.white24,
                        fontSize: 16.0,
                        fontFamily: "NEXA",
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 80.0,
              // ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              print(MediaQuery.of(context).padding.top);
              print(MediaQuery.of(context).padding.bottom);
              if (textController.text.isNotEmpty) {
                reportBug();
                textController.clear();
                showGeneralDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionBuilder: (context, a1, a2, widget) {
                    dialogContext = context;
                    return Transform.scale(
                      scale: a1.value,
                      child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                            title: Center(child: CheckAnimation()),
                            // contentPadding: EdgeInsets.only(top: 20.0),
                            content: Text('Your request submitted successfully',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "NEXA",
                                  fontWeight: FontWeight.bold,
                                )),
                            backgroundColor: Color.fromARGB(255, 25, 27, 45),
                          )),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 300),
                  barrierDismissible: true,
                  barrierLabel: '',
                  context: context,
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {},
                );
                Future.delayed(
                    Duration(seconds: 3), () => Navigator.pop(dialogContext));
              }
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blueAccent,
                        Colors.blueAccent,
                      ])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Submit Request",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.3,
                          fontFamily: "NEXA",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
