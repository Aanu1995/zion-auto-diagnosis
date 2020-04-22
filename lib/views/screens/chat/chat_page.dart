import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/views/components/shimmer.dart';
import 'package:zion/views/screens/chat/components/group/group_chat_widget.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  UserProfile userProfile;
  List chatList = [];

  @override
  void initState() {
    super.initState();
    userProfile = Provider.of<UserProvider>(context, listen: false).userProfile;
  }

  @override
  Widget build(BuildContext context) {
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
              // displays the admin profile in the chat
              return SizedBox.expand(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Stream.value(Provider.of<QuerySnapshot>(context)),
                  builder: (context, allChatsSnapshot) {
                    if (allChatsSnapshot.hasData &&
                        allChatsSnapshot.connectionState ==
                            ConnectionState.done) {
                      final allChats = allChatsSnapshot.data.documents;
                      if (allChats.length == 0) {
                        return Container();
                      }
                      return ListView.builder(
                        itemCount: allChats.length,
                        itemBuilder: (context, index) {
                          final chat = allChats[index];
                          if (groups.contains(chat.documentID)) {
                            Group group = Group.fromMap(map: chat.data);
                            return GroupChatWidget(
                              group: group,
                              user: userProfile,
                            );
                          }
                          return Offstage();
                        },
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
/* 
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
 */
