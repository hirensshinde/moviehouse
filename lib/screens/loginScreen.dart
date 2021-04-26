import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:movie_house4/provider/google_sign_in.dart';
import 'package:movie_house4/screens/homescreen.dart';

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
            return HomeScreen();
          } else {
            return SignUpWidget();
          }
        },
      ),
    ));
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());
}

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            width: 175.0,
            child: Text('Welcome to Movie House',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        Spacer(),
        GoogleSignInButton(
          borderRadius: 20.0,
          // centered: true,
          darkMode: true,
          // splashColor: Colors.orange,
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
        ),
        SizedBox(height: 10.0),
        Text(
          'Login to continue',
          style: TextStyle(fontSize: 16.0),
        ),
        Spacer(),
      ],
    );
  }
}
