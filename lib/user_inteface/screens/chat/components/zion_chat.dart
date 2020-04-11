import 'package:cached_network_image/cached_network_image.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/user_inteface/screens/chat/components/full_image.dart';

class ZionChat extends StatefulWidget {
  final chatKey;
  final List<ChatMessage> messages;
  final ChatUser user;
  final void Function() onImagePicked;
  const ZionChat({this.chatKey, this.messages, this.user, this.onImagePicked});

  @override
  _ZionChatState createState() => _ZionChatState();
}

class _ZionChatState extends State<ZionChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DashChat(
      key: widget.chatKey,
      height: MediaQuery.of(context).size.height,
      onSend: (message) =>
          ChatServcice.sendMessage(message: message, userId: widget.user.uid),
      user: widget.user,
      inputDecoration: InputDecoration.collapsed(hintText: "Type a message"),
      timeFormat: DateFormat('h:mm a'),
      messages: widget.messages,
      inputMaxLines: 6,
      alwaysShowSend: true,
      messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
      inputTextStyle: TextStyle(fontSize: 16.0),
      inputContainerStyle: BoxDecoration(
        border: Border.all(width: 0.0),
        color: Colors.white,
      ),
      messageImageBuilder: (image) {
        return Hero(
          tag: image,
          child: Material(
            child: InkWell(
              child: CachedNetworkImage(
                imageUrl: image,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fitWidth,
                placeholder: (context, value) {
                  return Center(
                    child: SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        )),
                  );
                },
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullImage(imageUrl: image, hero: image),
                ),
              ),
            ),
          ),
        );
      },
      shouldShowLoadEarlier: true,
      leading: IconButton(
        icon: Icon(Icons.photo),
        onPressed: widget.onImagePicked,
      ),
    );
  }
}
