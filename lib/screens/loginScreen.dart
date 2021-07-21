import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviehouse/models/navigation_item.dart';
import 'package:moviehouse/provider/google_sign_in.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:moviehouse/screens/bugreport.dart';
import 'package:moviehouse/screens/homescreen.dart';
import 'package:moviehouse/screens/savedContentScreen.dart';
import 'package:moviehouse/screens/subscriptionScreen.dart';
import 'package:moviehouse/screens/updateScreen.dart';
import 'package:moviehouse/widgets/signUpWidget.dart';
import 'package:moviehouse/widgets/updateWidget.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String apiKey;

  Future<void> generateApiKey() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user.uid;

    http.Response response = await http.get(Uri.parse(
        'https://api.moviehouse.download/api/key/genrate?uid=$userId'));

    if (response.statusCode == 200) {
      var results = jsonDecode(response.body);

      apiKey = results['api_key'];

      print("APIKEY Generated Succesfully: $apiKey");
    } else {
      throw Exception('Failed with exception');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);
              if (provider.isSigningIn) {
                generateApiKey();
                print("Called from Streambuilder::: ===> $apiKey");
                return buildLoading();
              } else if (snapshot.hasData) {
                // Future.delayed(Duration(seconds: 1));
                return buildPages(context);
              } else {
                return SignUpWidget();
              }
            },
          ),
        ));
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());

  Widget buildPages(context) {
    final provider = Provider.of<NavigationProvider>(context);
    final navigationItem = provider.navigationItem;

    print("Called from here::: ===> $apiKey");

    switch (navigationItem) {
      case NavigationItem.home:
        generateApiKey();
        print("Called from Swtich::: ===> $apiKey");
        return UpdateApp(child: HomeScreen(apiKey: apiKey));

      case NavigationItem.subscription:
        return SubscriptionScreen();
      case NavigationItem.savedContent:
        return SavedContentScreen();
      case NavigationItem.updates:
        return UpdateScreen();
      case NavigationItem.bugreport:
        return BugReport();
      default:
        return HomeScreen();
    }
  }
}
