import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zion/model/chatmodel.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/views/components/empty_space.dart';
import 'package:zion/views/screens/chat/components/zion_chat.dart';
import 'package:zion/views/screens/chat/components/zionchat/zion.dart';
import 'package:zion/views/screens/settings/components/components.dart';
import 'package:zion/views/utils/firebase_utils.dart';
import 'package:zion/views/utils/imageUtils.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdminChatPage extends StatelessWidget {
  final ChatModel oneone;
  final user;
  final UserProfile responderProfile;
  AdminChatPage({
    this.user,
    this.oneone,
    this.responderProfile,
  });

  final GlobalKey<ZionMessageChatState> _chatViewKey =
      GlobalKey<ZionMessageChatState>();

  final textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 13.0,
  );

  Widget userTyping() {
    final now = new DateTime.now();
    final difference = now.difference(responderProfile.lastActive);
    String lastSeen = timeago.format(now.subtract(difference));
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(oneone.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.data == null) {
          return Text(
            responderProfile.online ? 'Online' : lastSeen,
            style: textStyle,
          );
        } else {
          String memberId = snapshot.data.data['typing'];
          if (memberId != null && memberId.isNotEmpty && memberId != user.id) {
            return Text(
              'typing',
              style: textStyle,
            );
          }
        }
        return Text(
          responderProfile.online ? 'Online' : lastSeen,
          style: textStyle,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomCircleAvatar(
              size: 40.0,
              profileURL: responderProfile.profileURL,
            ),
            EmptySpace(horizontal: true, multiple: 1.5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  responderProfile.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                userTyping(),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ImageUtils.chatBackground,
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(FirebaseUtils.chats)
                  .document(oneone.id)
                  .collection(FirebaseUtils.messages)
                  .orderBy('createdAt', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<DocumentSnapshot> items = snapshot.data.documents;
                  final messages =
                      items.map((i) => ChatMessage.fromJson(i.data)).toList();
                  // update the time that a message was read
                  ChatServcice.updateGroupCheckMessageTime(user.id, oneone.id);
                  return ZionChat(
                    chatKey: _chatViewKey,
                    messages: messages,
                    oneone: oneone,
                    lastDocumentSnapshot:
                        items.length != 0 ? items[items.length - 1] : null,
                    user: ChatUser(uid: user.id, name: ''),
                    isResponderOnline: responderProfile.online,
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
