import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/service/notification_service.dart';
import 'package:zion/views/screens/authentication/login_page.dart';
import 'package:zion/views/utils/exception_utils.dart';
import 'package:zion/views/utils/firebase_utils.dart';
import 'package:zion/views/utils/global_data_utils.dart';

class AuthService {
  // Create Account
  static Future<String> createAccount(UserProfile user, String password) async {
    try {
      final result = await FirebaseUtils.auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      final userProfile =
          await UserProfile.toMap(user: user, id: result.user.uid);
      FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(result.user.uid)
          .setData(userProfile);
      // returns success
      ChatServcice.chatWithAdmins(userId: result.user.uid);
      return FirebaseUtils.success;
    } catch (e) {
      String error = ExceptionUtils.authenticationException(e);
      return error;
    }
  }

// login to the app
  static Future<String> login(String email, String password) async {
    try {
      final result = await FirebaseUtils.auth
          .signInWithEmailAndPassword(email: email, password: password);
      // playerId (One signal notification)
      final playerId = await PushNotificationService.getPlayerId();
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(result.user.uid)
          .updateData({'notificationId': playerId});
      return FirebaseUtils.success;
    } catch (e) {
      String error = ExceptionUtils.authenticationException(e);
      return error;
    }
  }

  // sign out of the app
  static signOut(BuildContext context) async {
    await FirebaseUtils.auth.signOut();
    final darkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;
    var box = await Hive.openBox(GlobalDataUtils.zion);
    await box.clear();
    box.put(GlobalDataUtils.darkTheme, darkTheme);
    // Takes user to login page after signing out
    pushDynamicScreen(
      context,
      screen: MaterialPageRoute(builder: (context) => LoginPage()),
      platformSpecific: true,
      withNavBar: false,
    );
  }
}
