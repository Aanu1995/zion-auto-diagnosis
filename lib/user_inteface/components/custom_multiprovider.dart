import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';

class CustomMultiprovider extends StatefulWidget {
  final child;
  const CustomMultiprovider({this.child});

  @override
  _CustomMultiproviderState createState() => _CustomMultiproviderState();
}

class _CustomMultiproviderState extends State<CustomMultiprovider> {
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
      child: widget.child,
    );
  }
}
