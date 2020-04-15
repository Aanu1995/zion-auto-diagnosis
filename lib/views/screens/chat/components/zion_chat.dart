import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/views/screens/chat/components/full_image.dart';
import 'package:zion/views/screens/chat/components/zionchat/zion.dart';
import 'package:zion/views/screens/chat/components/image_pick_preview_page.dart';

class ZionChat extends StatefulWidget {
  final chatKey;
  List<ChatMessage> messages;
  final bool online;
  DocumentSnapshot lastDocumentSnapshot;
  final ChatUser user;
  ZionChat(
      {this.chatKey,
      this.messages,
      this.user,
      this.lastDocumentSnapshot,
      this.online});

  @override
  _ZionChatState createState() => _ZionChatState();
}

class _ZionChatState extends State<ZionChat> {
  List<ChatMessage> messages = [];
  //checks if the loadmore button as been clicked
  // displays loading indicator if true
  bool isLoadingMore = false;
  List<ChatMessage> falseMessages = [];

  @override
  Widget build(BuildContext context) {
    messages = [...falseMessages, ...widget.messages];
    // set false images to null
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
  void onSend(ChatMessage message) {
    final mess = message;
    mess.messageStatus =
        widget.online ? 1 : 0; // checks whether messages will be delivered
    ChatServcice.sendMessage(message: mess, userId: widget.user.uid);
  }

// send chat images to the server
  void onSendImage() async {
    //pick images from the gallery
    File result = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (result != null) {
      // navigate to screen to preview image and add a caption to the image
      final text = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImagePickPreviewPage(image: result),
      ));
      if (text != null) {
        ChatMessage message = ChatMessage(
          text: text,
          messageStatus: -1,
          user: widget.user,
          imageFile: result,
        );
        falseMessages.add(message);
        setState(() {});
        await ChatServcice.sendImage(
          file: result,
          text: text,
          user: widget.user,
          id: widget.user.uid,
          messageStatus: widget.online ? 1 : 0,
        );
        // empty the false messages
        falseMessages.clear();
      }
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
