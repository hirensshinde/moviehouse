import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';

class BugReport extends StatefulWidget {
  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Tell me our Bug', style: TextStyle(fontSize: 20.0)),
        leading: Builder(
          builder: (context) => IconButton(
              splashRadius: 30.0,
              padding: EdgeInsets.all(0.0),
              icon: SvgPicture.asset(
                'assets/icons/Drawer2.svg',
                height: 35.0,
              ),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !showFab
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
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "and \n issues you are facing now",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.white)),
                  ]),
                )),
            Text(
              "We will resolve it within 72 hrs.",
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
                height: 100.0,
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
                        // textController.clear();
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
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 16.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
