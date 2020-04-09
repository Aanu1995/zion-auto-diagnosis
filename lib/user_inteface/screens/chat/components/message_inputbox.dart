import 'package:flutter/material.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';

class MyTextField extends StatefulWidget {
  final String userId;
  const MyTextField({this.userId});
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 6,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: 10.0, top: 2.0, bottom: 2.0, right: 10.0),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorUtils.primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintText: "Type a message",
              ),
            ),
          ),
          SizedBox(width: 8.0),
          InkWell(
              child: CircleAvatar(
                backgroundColor: ColorUtils.primaryColor,
                child: Icon(Icons.send, color: Colors.white),
              ),
              onTap: () async {
                bool value = await ChatServcice.sendMessage(
                  chat: ChatModel(message: controller.text.toString()),
                  userId: widget.userId,
                );
                if (value) {
                  setState(() {
                    controller.clear();
                  });
                }
              })
        ],
      ),
    );
  }
}
