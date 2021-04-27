import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:movie_house4/models/navigation_item.dart';
import 'package:movie_house4/provider/google_sign_in.dart';
import 'package:movie_house4/provider/navigationProvider.dart';
import 'package:movie_house4/screens/downloadsScreen.dart';
import 'package:movie_house4/screens/homescreen.dart';
import 'package:movie_house4/screens/savedContentScreen.dart';
import 'package:movie_house4/screens/subscriptionScreen.dart';
import 'package:movie_house4/screens/updateScreen.dart';
import 'package:movie_house4/widgets/signUpWidget.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context);
          if (provider.isSigningIn) {
            return buildLoading();
          } else if (snapshot.hasData) {
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

    switch (navigationItem) {
      case NavigationItem.home:
        return HomeScreen();
      case NavigationItem.subscription:
        return SubscriptionScreen();
      case NavigationItem.downloads:
        return DownloadsScreen();
      case NavigationItem.savedContent:
        return SavedContentScreen();
      case NavigationItem.updates:
        return UpdateScreen();
    }
  }
}
