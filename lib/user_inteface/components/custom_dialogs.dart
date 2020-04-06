import 'package:flutter/material.dart';

class CustomDialogs {
  // displays permission dialogs to the user
  static Future permissionDialog({BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notification Permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'To continue, turn on device notification in Settings. This is require to notify you of new messages.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
