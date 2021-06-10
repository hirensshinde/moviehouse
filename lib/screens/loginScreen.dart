import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviehouse/models/navigation_item.dart';
import 'package:moviehouse/provider/google_sign_in.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:moviehouse/screens/categoryScreen.dart';
import 'package:moviehouse/screens/downloadsScreen.dart';
import 'package:moviehouse/screens/savedContentScreen.dart';
import 'package:moviehouse/screens/searchScreen.dart';
import 'package:moviehouse/screens/subscriptionScreen.dart';
import 'package:moviehouse/screens/updateScreen.dart';
import 'package:moviehouse/widgets/signUpWidget.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
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
        return CategoryScreen();
      case NavigationItem.subscription:
        return SubscriptionScreen();
      case NavigationItem.downloads:
        return DownloadsScreen();
      case NavigationItem.savedContent:
        return SavedContentScreen();
      case NavigationItem.updates:
        return UpdateScreen();
      default:
        return SearchScreen();
    }
  }
}
