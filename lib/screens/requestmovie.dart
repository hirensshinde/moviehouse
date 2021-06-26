import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestMovie extends StatefulWidget {
  @override
  _RequestMovieState createState() => _RequestMovieState();
}

class _RequestMovieState extends State<RequestMovie> {
  TextEditingController textController = TextEditingController();
  List contents = [];
  ScrollController controller;
  bool fabIsVisible = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      // drawer: NavigationDrawerWidget(),
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Request Movie', style: TextStyle(fontSize: 20.0)),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              label: Text('Submit Request',
                  style: TextStyle(color: Colors.white, fontSize: 18.0)),
              onPressed: () {},
            )
          : null,

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Text('Request Your \n Movies & Web Series',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Text(
              "We will add content within 48 hrs.",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Color.fromARGB(255, 2, 198, 151),
                  ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                width: size.width * 0.9,
                // margin: EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
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
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 16.0),
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
                    height: 40.0,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    // color: Colors.grey[400],
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${index + 1}. ${contents[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              )),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20.0,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                contents.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    ),
                  );
                }),

            SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }
}
