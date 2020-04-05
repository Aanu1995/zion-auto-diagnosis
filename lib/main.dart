import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zion/router/router.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';

// our application starts running here
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
