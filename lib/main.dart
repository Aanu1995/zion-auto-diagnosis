import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zion/controller/chat_streams.dart';
import 'package:zion/model/app.dart';
import 'package:zion/router/router.dart';
import 'package:zion/views/components/custom_multiprovider.dart';
import 'package:zion/views/screens/authentication/login_page.dart';
import 'package:zion/views/screens/my_home_page.dart';
import 'package:zion/views/screens/splash_page.dart';
import 'package:zion/views/utils/global_data_utils.dart';
import 'package:zion/views/utils/theme_utils.dart';

// our application starts running here
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CustomMultiprovider(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // by default the user has not been authenticated
  // user will be taken to login screen
  Widget page = LoginPage();
  ChatStreams _chatStreams = ChatStreams();

  @override
  void initState() {
    super.initState();
    // One signal initialization
    initPlatformState();
    // has user logged in or not
    authenticationStatus();
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

  // checks if user has been authenticated
  void authenticationStatus() async {
    // takes user to home page if authenticated else login page
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      page = MyHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Consumer<SplashAppStatus>(
      builder: (context, status, _) {
        if (status.isLoading) {
          return MaterialApp(
            title: 'Zion Auto Diagnosis',
            debugShowCheckedModeBanner: false,
            home: SplashPage(), // defines the routes of the application
          );
        } else {
          return Consumer<AppModel>(
            builder: (context, app, _) {
              return MaterialApp(
                title: 'Zion Auto Diagnosis',
                theme: app.darkTheme
                    ? ThemeUtils.buildDarkTheme()
                    : ThemeUtils.buildLightTheme(),
                debugShowCheckedModeBanner: false,
                home: MultiProvider(
                  providers: [
                    StreamProvider<QuerySnapshot>(
                      create: (_) => _chatStreams.allChatsStream,
                    )
                  ],
                  child: page,
                ),
                routes:
                    Routes.getroutes, // defines the routes of the application
              );
            },
          );
        }
      },
    );
  }
}
