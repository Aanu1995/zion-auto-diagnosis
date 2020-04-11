import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/chat/components/zion_chat.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class AdminChatPage extends StatefulWidget {
  final String userId;
  final UserProfile profile;
  AdminChatPage({
    this.userId,
    this.profile,
  });

  @override
  _AdminChatPageState createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomCircleAvatar(
              size: 40.0,
              profileURL: widget.profile.profileURL,
            ),
            EmptySpace(horizontal: true, multiple: 1.5),
            Text(
              widget.profile.name,
              style: GoogleFonts.abel(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(FirebaseUtils.chat)
              .document(widget.userId)
              .collection(FirebaseUtils.admin)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> items = snapshot.data.documents;
              final messages =
                  items.map((i) => ChatMessage.fromJson(i.data)).toList();
              return ZionChat(
                chatKey: _chatViewKey,
                messages: messages,
                user: ChatUser(uid: widget.userId),
                onImagePicked: onImagePicked,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

// send images picked during chat to the server
  void onImagePicked() async {
    File result = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (result != null) {
      ChatServcice.sendImage(file: result, user: ChatUser(uid: widget.userId));
    }
  }
}
