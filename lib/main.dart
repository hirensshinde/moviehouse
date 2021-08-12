import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moviehouse/screens/bugreport.dart';
// import 'package:moviehouse/screens/categoryScreen.dart';
import 'package:moviehouse/screens/homescreen.dart';
import 'package:moviehouse/screens/loginScreen.dart';
import 'package:moviehouse/screens/updateScreen.dart';
import 'package:moviehouse/widgets/updateWidget.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  runZonedGuarded<Future<void>>(() async {
    // Overriding all Flutter uncaught errors to Firebase Crashlytics Errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => UpdateApp(child: HomeScreen()),
          '/bugreport': (context) => BugReport(),
          '/update': (context) => UpdateScreen(),
        },
        title: 'Movie House',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: LoginScreen(),
      ),
    );
  }
}
