import 'package:flutter/material.dart';
import 'package:movie_house4/provider/navigationProvider.dart';
import 'package:movie_house4/widgets/sidebarWidget.dart';

class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Subscription'),
        // centerTitle: true,
      ),
      body: Container(
        color: Colors.black45,
      ),
    );
  }
}
