import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';
import 'package:zion/views/components/custom_dialogs.dart';
import 'package:zion/views/utils/color_utils.dart';
import 'package:zion/views/utils/imageUtils.dart';

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

// this delays the screen for 3 seconds
  void delay() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // takes the user to the login screen after 2 seconds
      await Future.delayed(Duration(seconds: 2));
      // calls notifications function
      checkNotificationPermissionStatus();
      Provider.of<SplashAppStatus>(context, listen: false).setLoading = false;
    });
  }

// checks if notification permission is allowed on the user device
  void checkNotificationPermissionStatus() async {
    // If you want to know if the user allowed/denied permission,
    OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    // checks if notification permission is granted
    final result = await OneSignal.shared.getPermissionSubscriptionState();
    if (result.permissionStatus.status != OSNotificationPermission.authorized) {
      // opens permission dialog
      await CustomDialogs.permissionDialog(context: context);
      // opens app settings for user to enable notification permission
      AppSettings.openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.statusBarColor,
      body: Container(
        child: Center(
          child: Image.asset(
            ImageUtils.logo,
            height: 150.0,
            color: Colors.white,
            width: double.maxFinite,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
