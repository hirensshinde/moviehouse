import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';

class SavedContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Saved Contents'),
        backgroundColor: Color.fromARGB(255, 25, 27, 45),
        leading: Builder(
          builder: (context) => IconButton(
              splashRadius: 25.0,
              padding: EdgeInsets.all(0.0),
              icon: SvgPicture.asset(
                'assets/icons/Drawer2.svg',
                height: 35.0,
              ),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        // centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Text("Coming Soon",
              style: TextStyle(fontSize: 22.0, color: Colors.white)),
        ),
      ),
    );
  }
}
