import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/screens/authentication/login_page.dart';
import 'package:zion/user_inteface/utils/exception_utils.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class AuthService {
  // Create Account
  static Future<String> createAccount(UserProfile user, String password) async {
    try {
      final result = await FirebaseUtils.auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(result.user.uid)
          .setData(UserProfile.toMap(user: user));
      return FirebaseUtils.success;
    } catch (e) {
      String error = ExceptionUtils.authenticationException(e);
      return error;
    }
  }

// login to the app
  static Future<String> login(String email, String password) async {
    try {
      await FirebaseUtils.auth
          .signInWithEmailAndPassword(email: email, password: password);
      return FirebaseUtils.success;
    } catch (e) {
      String error = ExceptionUtils.authenticationException(e);
      return error;
    }
  }

  // sign out of the app
  static signOut(BuildContext context) async {
    await FirebaseUtils.auth.signOut();
    // Takes user to login page after signing out
    pushDynamicScreen(
      context,
      screen: MaterialPageRoute(builder: (context) => LoginPage()),
      platformSpecific: true,
      withNavBar: false,
    );
  }
}
