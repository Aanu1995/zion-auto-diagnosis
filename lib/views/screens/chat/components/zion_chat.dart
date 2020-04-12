import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/views/screens/chat/components/full_image.dart';
import 'package:zion/views/screens/chat/components/zionchat/zion.dart';

class ZionChat extends StatefulWidget {
  final chatKey;
  List<ChatMessage> messages;
  DocumentSnapshot lastDocumentSnapshot;
  final ChatUser user;
  ZionChat({this.chatKey, this.messages, this.user, this.lastDocumentSnapshot});

  @override
  _ZionChatState createState() => _ZionChatState();
}

class _ZionChatState extends State<ZionChat> {
  List<ChatMessage> messages = [];
  //checks if the loadmore button as been clicked
  // displays loading indicator if true
  bool isLoadingMore = false;

  @override
  Widget build(BuildContext context) {
    messages = widget.messages;
    // checks if the messages has been seen
    messages.forEach((chat) {
      if (chat.messageStatus >= 0 && chat.user.uid != widget.user.uid) {
        if (chat.messageStatus != 2) {
          ChatServcice.updateMessageStatus(
            userId: widget.user.uid,
            status: 2,
            documentId: chat.documentId,
          );
        }
      }
    });
    print(messages.length);
    return ZionMessageChat(
      key: widget.chatKey,
      onSend: onSend,
      user: widget.user,
      inputDecoration: InputDecoration.collapsed(hintText: "Type a message"),
      timeFormat: DateFormat('h:mm a'),
      messages: messages,
      inputMaxLines: 6,
      alwaysShowSend: true,
      messageImageBuilder: (image, file) {
        return image != null
            ? Hero(
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
                        builder: (context) =>
                            FullImage(imageUrl: image, hero: image),
                      ),
                    ),
                  ),
                ),
              )
            : Image.file(
                file,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fitWidth,
              );
      },
      shouldShowLoadEarlier: true,
      isLoadingMore: isLoadingMore,
      onLoadEarlier: () => loadMore(),
      leading: IconButton(
        icon: Icon(Icons.photo),
        onPressed: () => onSendImage(),
      ),
    );
  }

// send chat messages (text)
  void onSend(final message) {
    ChatServcice.sendMessage(message: message, userId: widget.user.uid);
  }

// send chat images to the server
  void onSendImage() async {
    // send images picked during chat to the server
    File result = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (result != null) {
      ChatMessage message = ChatMessage(
        text: "",
        messageStatus: -1,
        user: widget.user,
        imageFile: result,
      );
      widget.messages = [message, ...widget.messages];
      setState(() {});
      ChatServcice.sendImage(
          file: result, user: widget.user, id: widget.user.uid);
    }
  }

//loads more images from the server
  void loadMore() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isLoadingMore = true;
      setState(() {});
    });
    List<DocumentSnapshot> result = await ChatServcice.loadMoreMessages(
        widget.user.uid, widget.lastDocumentSnapshot);
    if (result.isNotEmpty) {
      widget.lastDocumentSnapshot = result[result.length - 1];
      final newMessages =
          result.map((i) => ChatMessage.fromJson(i.data)).toList();
      widget.messages.addAll(newMessages);
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isLoadingMore = false;
      setState(() {});
    });
  }
}
