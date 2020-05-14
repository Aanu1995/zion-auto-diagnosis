import 'package:flutter/material.dart';
import 'package:zion/views/screens/authentication/login_page.dart';
import 'package:zion/views/screens/authentication/signup_page.dart';
import 'package:zion/views/screens/settings/profile_page.dart';

class Routes {
  static const String LOGINPAGE = '/login';
  static const String SIGNUPPAGE = '/signup';
  static const String PROFILE = "/profile";
  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        LOGINPAGE: (context) => LoginPage(),
        SIGNUPPAGE: (context) => SignupPage(),
        PROFILE: (context) => ProfilePage(),
      };
}
