import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zion/router/router.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';
import 'package:zion/user_inteface/utils/global_data_utils.dart';

// our application starts running here
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // One signal initialization
    initPlatformState();
  }

  // intializes the function for one signal notification
  Future<void> initPlatformState() async {
    if (!mounted) return;

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    OneSignal.shared.setRequiresUserPrivacyConsent(requiresConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    // initialize one signal in the app
    await OneSignal.shared.init(GlobalDataUtils.appId, iOSSettings: settings);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorUtils.statusBarColor,
    ));
    return MaterialApp(
      title: 'Zion Auto Diagnosis',
      theme: ThemeData(
        // defines the primary color and the accent color
        primaryColor: ColorUtils.primaryColor,
        accentColor: ColorUtils.primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.getroutes, // defines the routes of the application
    );
  }
}
