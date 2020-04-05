import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zion/router/router.dart';
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

// this delays the screen for 3 seconds
  void delay() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // takes the user to the login screen after 2 seconds
      await Future.delayed(Duration(seconds: 2));
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
