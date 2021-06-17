import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviehouse/models/update.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
// import 'package:talkfootball/constants.dart';
// import 'package:talkfootball/dialogs/do_not_ask_again_dialog.dart';
// import 'package:talkfootball/models/app_version.dart';

class UpdateApp extends StatefulWidget {
  final Widget child;

  UpdateApp({this.child});

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  String _url;

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

      _url = "http://moviehouse.download/" + appVersion.link;
      setState(() {});
      if (latestAppVersion > currentVersion) {
        _showCompulsoryUpdateDialog(
          context,
          "Please update the app to continue\n${appVersion.about ?? ""}",
        );
      } else {
        print('App is up to date');
      }
    }
  }

  _onUpdateNowClicked() async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
    print(_url);
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
    return widget.child;
  }
}
