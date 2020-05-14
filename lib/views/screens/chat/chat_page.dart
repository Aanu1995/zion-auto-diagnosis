import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:zion/model/allchats.dart';

import 'package:zion/model/profile.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/views/components/shimmer.dart';
import 'package:zion/views/screens/chat/components/chat_widget.dart';
import 'package:zion/views/screens/chat/components/group/group_chat_widget.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key key}) : super(key: key);

  static UserProfile userProfile;
  static List chatList = [];

  @override
  Widget build(BuildContext context) {
    userProfile = Provider.of<UserProvider>(context).userProfile;
    List<AllChat> chats = Provider.of<List<AllChat>>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        child: chats != null
            ? ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 90.0, right: 16.0),
                    child: Divider(height: 8.0),
                  );
                },
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return chat.isGroup
                      ? GroupChatWidget(
                          group: chat.group,
                          user: userProfile,
                          unread: chat.unread,
                        )
                      : ChatWidget(
                          oneone: chat.oneone,
                          user: userProfile,
                          unread: chat.unread,
                        );
                },
              )
            : ShimmerLoadingList(),
      ),
    );
  }
}
