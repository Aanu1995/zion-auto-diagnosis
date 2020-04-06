import 'package:flutter/material.dart';

class CustomButtomSheets {
  //shows message when the device has no internet connection
  static showConnectionError(BuildContext context) {
    String text1 = "You seem to be offline! \n\n";
    String text2 =
        "Please check your Wifi network or Data service and try again. We love you!.";
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 80,
          margin:
              EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: text1,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                TextSpan(
                  text: text2,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.2,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
