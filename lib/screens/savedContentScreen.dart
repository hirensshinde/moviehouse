import 'package:flutter/material.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';

class SavedContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Saved Contents'),
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
