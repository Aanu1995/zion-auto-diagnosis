import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/views/components/shimmer.dart';
import 'package:zion/views/screens/chat/admin_chat_page.dart';
import 'package:zion/views/screens/chat/components/zionchat/zion.dart';
import 'package:zion/views/screens/settings/components/components.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseUser user; // firebase user

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Stream.value(Provider.of<QuerySnapshot>(context)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final responderProfile =
                  UserProfile.fromMap(map: snapshot.data.documents[0].data);
              // displays the admin profile in the chat
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection(FirebaseUtils.chat)
                    .document(user.uid)
                    .collection(FirebaseUtils.admin)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, messagesSnapshot) {
                  if (messagesSnapshot.hasData) {
                    /// gets the time the user read from the chat
                    /// use it to determine the count of unread messages
                    /// Also gets the latest message and time of the chat
                    return FutureBuilder(
                      future: getLatestData(messagesSnapshot.data, user.uid),
                      builder: (context, chatData) {
                        if (chatData.hasData) {
                          return ChatWidget(
                            chatData: chatData.data,
                            user: user,
                            responderProfile: responderProfile,
                          );
                        }
                        return ChatWidget(
                          chatData: ChatData(),
                          user: user,
                          responderProfile: responderProfile,
                        );
                      },
                    );
                  }
                  return ChatWidget(
                    chatData: ChatData(),
                    user: user,
                    responderProfile: responderProfile,
                  );
                },
              );
            }
            return ShimmerLoadingItem();
          },
        ),
      ),
    );
  }

// gets latest unread messages from the server
  /// use it to determine the count of unread messages
  /// Also gets the latest message and time of the chat
  Future<ChatData> getLatestData(QuerySnapshot snapshot, String chatId) async {
    int count = 0;
    final messages = snapshot.documents;
    ChatMessage lastMessage = ChatMessage.fromJson(messages[0].data);
    final document = await Firestore.instance
        .collection(FirebaseUtils.chat)
        .document(chatId)
        .get();
    final userLastSeenTime =
        document.data[user.uid] + 5000; // a delay of 5 seconds
    if (userLastSeenTime != null) {
      messages.forEach((mess) {
        int messTime = int.parse(mess.documentID);
        if (userLastSeenTime < messTime) {
          count = count + 1;
        }
      });
    }
    return ChatData(
        lastMessage: lastMessage.text,
        time: DateFormat('h:mm a').format(lastMessage.createdAt),
        unreadMessages: count);
  }
}

class ChatWidget extends StatelessWidget {
  final UserProfile responderProfile;
  final ChatData chatData;
  final FirebaseUser user;
  const ChatWidget({this.chatData, this.user, this.responderProfile});

  Widget userTyping() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String isTyping = snapshot.data.data['typing'];
          if (isTyping != null && isTyping.isNotEmpty && isTyping != user.uid) {
            return Text(
              'Typing',
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 14.0,
              ),
            );
          }
        }
        return Expanded(
          child: Text(
            chatData.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 0.0, right: 12.0),
          leading: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 35.0,
                child: CustomCircleAvatar(
                  size: 56.0,
                  profileURL: responderProfile.profileURL,
                ),
              ),
              Positioned(
                bottom: 6.0,
                right: 6.0,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor:
                      responderProfile.online ? Colors.green : Colors.redAccent,
                ),
              )
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                responderProfile.name,
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                chatData.time,
                style: TextStyle(
                  color: chatData.unreadMessages > 0
                      ? Colors.green
                      : Colors.black54,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding:
                EdgeInsets.only(top: chatData.unreadMessages > 0 ? 0.0 : 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                userTyping(),
                if (chatData.unreadMessages > 0)
                  Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 16.0),
                    child: Badge(
                      badgeColor: Colors.green,
                      padding: EdgeInsets.all(6.0),
                      badgeContent: Text(
                        '${chatData.unreadMessages}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          onTap: () async {
            // takes user to the admin chat page
            pushDynamicScreen(
              context,
              screen: MaterialPageRoute(
                builder: (context) => AdminChatPage(
                  userId: user.uid,
                  responderProfile: responderProfile,
                ),
              ),
              platformSpecific: true,
              withNavBar: false,
            );
          },
        ),
      ),
    );
  }
}
