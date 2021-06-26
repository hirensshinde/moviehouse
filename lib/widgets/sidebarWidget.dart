import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviehouse/models/navigation_item.dart';
import 'package:moviehouse/provider/google_sign_in.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';

class NavigationDrawerWidget extends StatefulWidget {
  static final padding = EdgeInsets.symmetric(horizontal: 20.0);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  String _currentVersion;

  @override
  initState() {
    getVersion();
    super.initState();
  }

  Future getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Version currentVersion = Version.parse(packageInfo.version);
    setState(() {
      _currentVersion = currentVersion.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user.displayName ?? "";
    final userPhoto = user.photoURL ?? "";
    final userEmail = user.email ?? "";
    // final userId = user.uid;

    return Container(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(255, 25, 27, 45),
          child: Column(
            children: [
              buildHeader(
                context,
                userName: userName,
                userPhoto: userPhoto,
                userEmail: userEmail,
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: Container(
                  padding: NavigationDrawerWidget.padding,
                  // height: double.infinity,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Divider(color: Colors.white70),
                      SizedBox(height: 20.0),
                      buildMenuItem(
                        context,
                        item: NavigationItem.home,
                        text: "Home",
                        icon: Icons.subscriptions,
                      ),
                      // SizedBox(height: 18.0),
                      // buildMenuItem(
                      //   context,
                      //   item: NavigationItem.subscription,
                      //   text: "Subscription",
                      //   icon: Icons.subscriptions,
                      // ),
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

                      buildMenuItem(
                        context,
                        item: NavigationItem.bugreport,
                        text: "Report a bug",
                        icon: Icons.update,
                      ),
                      SizedBox(height: 24.0),

                      Divider(
                        color: Colors.white70,
                      ),
                      SizedBox(height: 15.0),
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

                      // SizedBox(height: 18.0),
                      Expanded(
                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Version: $_currentVersion",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 15.0),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        selectedTileColor: Colors.blue,
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
        padding: NavigationDrawerWidget.padding
            .add(EdgeInsets.symmetric(vertical: 15.0)),
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
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
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
