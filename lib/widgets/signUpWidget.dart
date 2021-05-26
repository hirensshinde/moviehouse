import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:movie_house4/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            // width: 175.0,
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/SplashLogo.png',
                ),
                // fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
          child: Container(
            height: 100,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/icons/GoogleLogin.png',
                ),
              ),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
