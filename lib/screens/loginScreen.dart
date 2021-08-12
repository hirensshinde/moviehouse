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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String apiKey;

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
