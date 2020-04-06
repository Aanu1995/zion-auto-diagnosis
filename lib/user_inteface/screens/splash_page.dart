import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zion/router/router.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    delay();
  }

  void checkNotificationPermissionStatus() async {
    // If you want to know if the user allowed/denied permission,
    OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    // checks if notification permission is granted
    final result = await OneSignal.shared.getPermissionSubscriptionState();
    if (result.permissionStatus.status != OSNotificationPermission.authorized) {
      await CustomDialogs.permissionDialog(context: context);
      AppSettings.openAppSettings();
    }
  }

// this delays the screen for 3 seconds
  void delay() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // takes the user to the login screen after 2 seconds
      await Future.delayed(Duration(seconds: 2));
      checkNotificationPermissionStatus();
      Router.goToReplacementScreen(context: context, page: Routes.LOGINPAGE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.statusBarColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.4),
            Image.asset(
              'assets/diagnose.png',
              height: 150.0,
              color: Colors.white,
              width: double.maxFinite,
              fit: BoxFit.contain,
            ),
            Text(
              "ZION",
              style: GoogleFonts.pacifico(
                color: Colors.white,
                fontSize: 70.0,
              ),
            ),
            Text(
              "Auto Diagnosis",
              style: GoogleFonts.pacifico(
                color: Colors.white,
                fontSize: 30.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
