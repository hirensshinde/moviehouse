import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(50, 55, 205, 1),
        child: ListView(
          children: [
            Container(
                child: Column(
              children: [
                SizedBox(height: 24.0),
                buildMenuItem(
                  context,
                  text: "Saved Content",
                  icon: Icons.favorite,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  buildMenuItem(
    BuildContext context, {
    String text,
    IconData icon,
  }) {
    final color = Colors.white;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          text,
          style: TextStyle(color: color),
        ),
        onTap: () {},
      ),
    );
  }
}
