export 'routes.dart';

import 'package:flutter/material.dart';

class Router {
  static goToScreen({BuildContext context, String page}) {
    Navigator.of(context).pushNamed(page);
  }

  static goToReplacementScreen({BuildContext context, String page}) {
    Navigator.of(context).pushReplacementNamed(page);
  }

  static goToWidget({BuildContext context, Widget page}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  static goToReplacementWidget({BuildContext context, Widget page}) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  static removeWidget({BuildContext context, Widget page}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false,
    );
  }

  static goBack({BuildContext context}) {
    Navigator.of(context).pop();
  }
}
