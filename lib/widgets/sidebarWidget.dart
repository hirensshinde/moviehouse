import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_house4/models/navigation_item.dart';
import 'package:movie_house4/provider/google_sign_in.dart';
import 'package:movie_house4/provider/navigationProvider.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  static final padding = EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user.displayName;
    final userPhoto = user.photoURL;
    final userEmail = user.email;
    final userId = user.uid;

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            buildHeader(
              context,
              userName: userName,
              userPhoto: userPhoto,
              userEmail: userEmail,
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  Divider(color: Colors.white24),
                  SizedBox(height: 24.0),
                  buildMenuItem(
                    context,
                    item: NavigationItem.home,
                    text: "Home",
                    icon: Icons.subscriptions,
                  ),
                  SizedBox(height: 18.0),
                  buildMenuItem(
                    context,
                    item: NavigationItem.subscription,
                    text: "Subscription",
                    icon: Icons.subscriptions,
                  ),
                  SizedBox(height: 18.0),
                  buildMenuItem(
                    context,
                    item: NavigationItem.savedContent,
                    text: "Saved Content",
                    icon: Icons.favorite,
                  ),
                  SizedBox(height: 18.0),
                  buildMenuItem(
                    context,
                    item: NavigationItem.updates,
                    text: "Updates",
                    icon: Icons.update,
                  ),
                  SizedBox(height: 18.0),
                  Divider(
                    color: Colors.white70,
                  ),
                  SizedBox(height: 24.0),
                  Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.white),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMenuItem(
    BuildContext context, {
    NavigationItem item,
    String text,
    IconData icon,
  }) {
    final color = Colors.white;
    final provider = Provider.of<NavigationProvider>(context);
    final currentItem = provider.navigationItem;
    final isSelected = item == currentItem;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Colors.white24,
        leading: Icon(icon, color: color),
        title: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16.0,
          ),
        ),
        onTap: () => selectedItem(context, item),
      ),
    );
  }

  selectedItem(BuildContext context, NavigationItem item) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.setNavigationItem(item);
  }

  buildHeader(BuildContext context, {userName, userPhoto, userEmail}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: padding.add(EdgeInsets.symmetric(vertical: 15.0)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(userPhoto),
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 16.0, color: Colors.white70),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(userEmail,
                    style: TextStyle(fontSize: 14.0, color: Colors.white70))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
