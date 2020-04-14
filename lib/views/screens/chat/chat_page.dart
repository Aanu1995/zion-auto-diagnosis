import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/views/screens/chat/admin_chat_page.dart';
import 'package:zion/views/screens/settings/components/components.dart';
import 'package:zion/views/utils/dependency_injection.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatServcice chatServcice;
  FirebaseUser user; // firebase user

  @override
  void initState() {
    super.initState();
    chatServcice = Provider.of<DependecyInjection>(
      context,
      listen: false,
    ).chatServcice;

    getUserId();
  }

  void getUserId() async {
    user = await FirebaseUtils.auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseUtils.firestore
              .collection(FirebaseUtils.admin)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userProfile = UserProfile.fromMap(
                map: snapshot.data.documents[0].data,
              );
              // displays the admin profile in the chat
              return ListTile(
                leading: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35.0,
                      child: CustomCircleAvatar(
                        size: 56.0,
                        profileURL: userProfile.profileURL,
                      ),
                    ),
                    Positioned(
                      bottom: 6.0,
                      right: 6.0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: userProfile.online
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                    )
                  ],
                ),
                title: Text(
                  userProfile.name,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () async {
                  // takes user to the admin chat page
                  pushDynamicScreen(
                    context,
                    screen: MaterialPageRoute(
                      builder: (context) => AdminChatPage(
                        userId: user.uid,
                        profile: userProfile,
                      ),
                    ),
                    platformSpecific: true,
                    withNavBar: false,
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
