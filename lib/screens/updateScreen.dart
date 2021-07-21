import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/navigation_item.dart';
import 'package:moviehouse/models/update.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:moviehouse/screens/homescreen.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  String _url;
  String text;
  GlobalKey<NavigatorState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    checkLatestVersion(context);
  }

  checkLatestVersion(context) async {
    await Future.delayed(Duration(seconds: 3));

    //Add query here to get the minimum and latest app version

    //Change
    //Here is a sample query to ParseServer(open-source NodeJs server with MongoDB database)
    var response = await http
        .get(Uri.parse('https://api.moviehouse.download/api/app/latest'));
    // QueryBuilder<Movie>(Movie())
    //   ..orderByDescending("publishDate")
    //   ..setLimit(1);

    if (response.statusCode == 200) {
      //Change
      var result = jsonDecode(response.body);
      AppVersion appVersion = AppVersion.fromJson(result['data']);

      Version latestAppVersion = Version.parse(appVersion.version);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Version currentVersion = Version.parse(packageInfo.version);

      _url = "http://moviehouse.download/${appVersion.link}";
      setState(() {});
      if (latestAppVersion > currentVersion) {
        _showCompulsoryUpdateDialog(
          context,
          "Please update the app to continue\n${appVersion.about ?? ""}",
        );
      } else {
        setState(() {
          text = 'App is up to date';
        });
      }
    }
  }

  _onUpdateNowClicked() async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      btnLabel,
                    ),
                    isDefaultAction: true,
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              )
            : WillPopScope(
                onWillPop: () async => false,
                child: new AlertDialog(
                  title: Text(
                    title,
                    style: TextStyle(fontSize: 22),
                  ),
                  content: Text(message),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(btnLabel),
                      onPressed: _onUpdateNowClicked,
                    ),
                  ],
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   context = widget.pageContext;
    // });
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        // drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Check Update'),
          backgroundColor: Color.fromARGB(255, 25, 27, 45),

          leading: IconButton(
            splashRadius: 25.0,
            padding: EdgeInsets.all(0.0),
            icon: SvgPicture.asset(
              'assets/icons/Back.svg',
              height: 35.0,
            ),
            onPressed: () {
              final provider =
                  Provider.of<NavigationProvider>(context, listen: false);
              provider.setNavigationItem(NavigationItem.home);
              return Navigator.of(context).pop();
            },
          ),
          // centerTitle: true,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: (text != null)
                ? Text(text,
                    style: TextStyle(fontSize: 22.0, color: Colors.white))
                : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
