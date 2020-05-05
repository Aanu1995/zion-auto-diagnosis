import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/views/components/shimmer.dart';
import 'package:zion/views/screens/chat/components/chat_widget.dart';
import 'package:zion/views/screens/chat/components/group/group_chat_widget.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key key}) : super(key: key);

  static UserProfile userProfile;
  static List chatList = [];

  @override
  Widget build(BuildContext context) {
    userProfile = Provider.of<UserProvider>(context).userProfile;
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseUtils.firestore
              .collection(FirebaseUtils.user)
              .document(userProfile.id)
              .collection(FirebaseUtils.groups)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.documents == null)
              Offstage();
            else if (snapshot.hasData) {
              final groups = [];
              snapshot.data.documents.forEach((id) {
                groups.add(id.documentID);
              });
              return SizedBox.expand(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Stream.value(Provider.of<QuerySnapshot>(context)),
                  builder: (context, allChatsSnapshot) {
                    if (allChatsSnapshot.hasData &&
                        allChatsSnapshot.connectionState ==
                            ConnectionState.done) {
                      final allChats = allChatsSnapshot.data.documents;
                      if (allChats.length == 0) return Container();
                      return ListView(
                        children: allChats.map((f) {
                          final chat = f;

                          if (groups.contains(chat.documentID)) {
                            final chatType = chat.data['chat_type'];
                            if (chatType == FirebaseUtils.group) {
                              Group group = Group.fromMap(map: chat.data);
                              return Column(
                                children: [
                                  GroupChatWidget(
                                      group: group, user: userProfile),
                                  if (allChats.length > 1 &&
                                      f.documentID !=
                                          allChats[allChats.length - 1]
                                              .documentID)
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 90.0, right: 16.0),
                                      child: Divider(height: 8.0),
                                    )
                                ],
                              );
                            }
                            if (chatType == FirebaseUtils.oneone) {
                              ChatModel oneone =
                                  ChatModel.fromMap(map: chat.data);
                              return Column(
                                children: [
                                  ChatWidget(oneone: oneone, user: userProfile),
                                  if (allChats.length > 1 &&
                                      f.documentID !=
                                          allChats[allChats.length - 1]
                                              .documentID)
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 90.0, right: 16.0),
                                      child: Divider(height: 8.0),
                                    )
                                ],
                              );
                            }
                          }
                          return Offstage();
                        }).toList(),
                      );
                    }
                    return ShimmerLoadingList();
                  },
                ),
              );
            }
            return ShimmerLoadingList();
          },
        ),
      ),
    );
  }
}
