import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialm/homepage.dart';
import 'package:socialm/login.dart';

import 'constent.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Constants.prefs = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    title: 'Weather',
    home: Constants.prefs.getBool("loggedIn") == true
        ? ProfilePage()
        : LoginPage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      "/logout": (context) => LoginPage(),
      "/home": (context) => ProfilePage(),
    },
  ));
}
