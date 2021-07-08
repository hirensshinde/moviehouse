import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/screens/successScreen.dart';
import 'package:http/http.dart' as http;

class RequestMovie extends StatefulWidget {
  final String apiKey;
  RequestMovie({this.apiKey});

  @override
  _RequestMovieState createState() => _RequestMovieState();
}

class _RequestMovieState extends State<RequestMovie> {
  TextEditingController textController = TextEditingController();
  List<String> contents = [];
  ScrollController controller;
  // bool fabIsVisible = true;

  Future<void> submitRequest() async {
    String apiKey = widget.apiKey;
    String values;
    if (contents.isNotEmpty) {
      values = contents.join(',');
    }
    var body = jsonEncode(<String, String>{
      'message': values,
    });

    print(body);

    http.Response response = await http.post(
      Uri.parse('https://api.moviehouse.download/api/request?api_key=$apiKey'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result['message']);
    } else {
      print(response.statusCode);
      throw Exception('Failed to submit request');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
        // drawer: NavigationDrawerWidget(),
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Request Movie',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "NEXA",
                fontWeight: FontWeight.bold,
                // letterSpacing: -0.24,
              )),
          leading: IconButton(
            splashRadius: 25.0,
            icon: SvgPicture.asset(
              'assets/icons/Back.svg',
              height: 40.0,
              width: 40.0,
            ),
            onPressed: () {
              return Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: size.height * .3,
                alignment: Alignment.center,
                child: Image.asset('assets/images/requestmovie.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Text('Request Your \n Movies & Web Series',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        fontFamily: "NEXA",
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              Text(
                "We will add content within 48 hrs.",
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
                  height: 50,
                  // margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color.fromARGB(255, 25, 27, 45),
                  ),
                  child: TextField(
                    controller: textController,
                    onSubmitted: (String value) async {
                      if (value.isNotEmpty) {
                        setState(() {
                          contents.add(value);
                          textController.clear();
                        });
                        print(contents);
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
                      hintText: "Enter Movie or Series name",
                      hintStyle: TextStyle(
                          color: Colors.white24,
                          fontFamily: "NEXA",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ListView.builder(
                  itemCount: contents.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      // width: MediaQuery.of(context).size.width * .9,
                      height: 40.0,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // color: Colors.grey[400],
                      child: Center(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${index + 1}. ${contents[index]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "NEXA",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    contents.removeAt(index);
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/Close2.svg',
                                  height: 15.0,
                                ),
                              ),

                              // IconButton(
                              //   icon: Icon(
                              //     Icons.close,
                              //     // size: 20.0,
                              //   ),
                              //   color: Colors.white,
                              //   onPressed: () {
                              //     setState(() {
                              //       contents.removeAt(index);
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        ),
                      ),
                    );
                  }),

              SizedBox(height: 80.0),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              if (contents.length > 0) {
                submitRequest();
                setState(() {
                  contents.clear();
                });
                BuildContext dialogContext;

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
