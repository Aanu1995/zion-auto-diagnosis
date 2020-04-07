import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';

class CustomMultiprovider extends StatelessWidget {
  final child;
  CustomMultiprovider({this.child});
  AppModel _appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SplashAppStatus(),
        ),
        ChangeNotifierProvider(
          create: (context) => _appModel,
        )
      ],
      child: child,
    );
  }
}
