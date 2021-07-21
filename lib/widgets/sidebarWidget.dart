import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviehouse/models/navigation_item.dart';
import 'package:moviehouse/provider/google_sign_in.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:moviehouse/screens/bugreport.dart';
import 'package:moviehouse/screens/homescreen.dart';
import 'package:moviehouse/screens/howToScreen.dart';
import 'package:moviehouse/screens/updateScreen.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final String apiKey;

  NavigationDrawerWidget({this.apiKey});

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

  final padding = EdgeInsets.symmetric(horizontal: 20.0);

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
          padding: EdgeInsets.only(top: 40.0, left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(255, 25, 27, 45),
          child: Column(
            children: [
              buildHeader(
                userName: userName,
                userPhoto: userPhoto,
                userEmail: userEmail,
              ),
              SizedBox(height: 20.0),
              Divider(color: Colors.white70),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // buildSearchField(),
                    // const SizedBox(height: 24),
                    buildMenuItem(
                      text: 'Home',
                      icon: Icons.home,
                      onClicked: () => selectedItem(context, 0),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'How to download',
                      icon: Icons.help,
                      onClicked: () => selectedItem(context, 1),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'Update',
                      icon: Icons.update,
                      onClicked: () => selectedItem(context, 2),
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: 'Report a bug',
                      icon: Icons.bug_report,
                      onClicked: () => selectedItem(context, 3),
                    ),
                    const SizedBox(height: 24),
                    // const SizedBox(height: 24),
                    // buildMenuItem(
                    //   text: 'Plugins',
                    //   icon: Icons.account_tree_outlined,
                    //   onClicked: () => selectedItem(context, 4),
                    // ),
                  ],
                ),
              ),
              Column(
                children: [
                  Divider(color: Colors.white70),
                  SizedBox(height: 15.0),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.white),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: "NEXA",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.logout();
                    },
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Version: $_currentVersion",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "NEXA",
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader({
    String userName,
    String userPhoto,
    String userEmail,
  }) =>
      Container(
        // padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(userPhoto)),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "NEXA",
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  userEmail,
                  style: TextStyle(
                      fontSize: 16.0, fontFamily: "NEXA", color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );

  Widget buildMenuItem({
    String text,
    IconData icon,
    VoidCallback onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(text,
            style: TextStyle(
              color: color,
              fontFamily: "NEXA",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        hoverColor: hoverColor,
        onTap: onClicked,
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        HomeScreen(apiKey: widget.apiKey);
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HowToScreen(),
        ));
        break;

      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UpdateScreen(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BugReport(apiKey: widget.apiKey),
        ));
        break;
    }
  }
}
