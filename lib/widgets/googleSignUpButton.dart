import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleSignInButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      // ignore: deprecated_member_use
      child: OutlineButton.icon(
        label: Text(
          'Sign in with Google',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        highlightedBorderColor: Colors.black,
        borderSide: BorderSide(color: Colors.black),
        icon: FaIcon(
          FontAwesomeIcons.google,
        ),
        onPressed: () {},
      ),
    );
  }
}
