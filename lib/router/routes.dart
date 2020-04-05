import 'package:flutter/material.dart';
import 'package:zion/user_inteface/screens/authentication/login_page.dart';
import 'package:zion/user_inteface/screens/authentication/signup_page.dart';
import 'package:zion/user_inteface/screens/my_home_page.dart';
import 'package:zion/user_inteface/screens/splash_page.dart';

class Routes {
  static const String SPLASHPAGE = '/';
  static const String LOGINPAGE = '/login';
  static const String SIGNUPPAGE = '/signup';
  static const String MYHOMEPAGE = "/myhomepage";
  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        SPLASHPAGE: (context) => SplashPage(),
        LOGINPAGE: (context) => LoginPage(),
        SIGNUPPAGE: (context) => SignupPage(),
        MYHOMEPAGE: (context) => MyHomePage(),
      };
}
