import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        child: Center(
          child: Text(
            "This is Settings Screen",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
