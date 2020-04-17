import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/views/components/empty_space.dart';
import 'package:zion/views/screens/chat/components/zion_chat.dart';
import 'package:zion/views/screens/chat/components/zionchat/zion.dart';
import 'package:zion/views/screens/settings/components/components.dart';
import 'package:zion/views/utils/firebase_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zion/views/utils/imageUtils.dart';

class AdminChatPage extends StatefulWidget {
  final String userId;
  final UserProfile responderProfile;
  const AdminChatPage({
    this.userId,
    this.responderProfile,
  });

  @override
  _AdminChatPageState createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final GlobalKey<ZionMessageChatState> _chatViewKey =
      GlobalKey<ZionMessageChatState>();

  String lastActive;

  @override
  void initState() {
    super.initState();
    final result =
        DateTime.now().difference(widget.responderProfile.lastActive);
    lastActive = timeago.format(DateTime.now().subtract(result));
  }

  Widget userTyping() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String isTyping = snapshot.data.data['typing'];
          if (isTyping != null &&
              isTyping.isNotEmpty &&
              isTyping != widget.userId) {
            return Text(
              'Typing',
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            );
          }
        }
        return Text(
          widget.responderProfile.online ? 'Online' : 'Last seen: $lastActive',
          style: GoogleFonts.abel(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
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
              profileURL: widget.responderProfile.profileURL,
            ),
            EmptySpace(horizontal: true, multiple: 1.5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.responderProfile.name,
                  style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                ),
                userTyping(),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            ImageUtils.chatBackground,
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            // gets messages in real time
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection(FirebaseUtils.chat)
                  .document(widget.userId)
                  .collection(FirebaseUtils.admin)
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
                  // send last seen of the user in the chat to the server
                  ChatServcice.updateLastSeen(widget.userId, widget.userId);
                  return ZionChat(
                    chatKey: _chatViewKey,
                    online: widget.responderProfile.online,
                    messages: messages,
                    lastDocumentSnapshot:
                        items.length != 0 ? items[items.length - 1] : null,
                    user: ChatUser(uid: widget.userId),
                    responderProfile: widget.responderProfile,
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
