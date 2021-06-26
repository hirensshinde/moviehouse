import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moviehouse/screens/bugreport.dart';
import 'package:moviehouse/screens/categoryScreen.dart';
import 'package:moviehouse/screens/loginScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  runApp(MyApp());
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
          '/home': (context) => CategoryScreen(),
          '/bugreport': (context) => BugReport(),
        },
        title: 'Movie House',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
