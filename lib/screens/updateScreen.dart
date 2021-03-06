import 'package:flutter/material.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('New Update'),
        // centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Text("Working on it :)",
              style: TextStyle(fontSize: 22.0, color: Colors.white)),
        ),
      ),
    );
  }
}
