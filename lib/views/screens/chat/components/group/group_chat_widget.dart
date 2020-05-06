import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/group_provider.dart';
import 'package:zion/views/screens/chat/components/group/group_chat_page.dart';
import 'package:zion/views/screens/settings/components/components.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class GroupChatWidget extends StatelessWidget {
  final Group group;
  final UserProfile user;
  const GroupChatWidget({this.group, this.user});

  @override
  Widget build(BuildContext context) {
    final time =
        DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(group.time));

    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0.0, right: 12.0),
        leading: CircleAvatar(
          radius: 28.0,
          backgroundColor: Colors.grey,
          child: CustomCircleAvatar(
            size: 67.0,
            profileURL: group.groupIcon,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                group.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              time,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: UserTyping(user: user, group: group),
              ),
              const SizedBox(width: 16.0),
              UnreadMessages(user: user, group: group),
            ],
          ),
        ),
        onTap: () async {
          // takes user to the group chat page
          Provider.of<CurrentGroupProvider>(context, listen: false).setGroup =
              group;
          pushDynamicScreen(
            context,
            screen: MaterialPageRoute(
              builder: (context) => GroupChatPage(user: user),
            ),
            platformSpecific: true,
            withNavBar: false,
          );
        },
      ),
    );
  }
}

class UnreadMessages extends StatelessWidget {
  final Group group;
  final UserProfile user;
  const UnreadMessages({this.group, this.user});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0, left: 16.0),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseUtils.firestore
            .collection(FirebaseUtils.chats)
            .document(group.id)
            .collection(FirebaseUtils.messages)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents == null) {
            return Offstage();
          } else {
            final messages = snapshot.data.documents;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseUtils.firestore
                  .collection(FirebaseUtils.user)
                  .document(user.id)
                  .collection(FirebaseUtils.groups)
                  .document(group.id)
                  .get(),
              builder: (context, snap) {
                print('Hello');
                if (!snap.hasData || snap.data.data == null) {
                  return Offstage();
                } else {
                  int unreadMessages = 0;
                  messages.forEach((mess) {
                    int messTime = int.parse(mess.documentID);
                    int lastSeen = snap.data.data['time'];
                    if (lastSeen < messTime) {
                      unreadMessages = unreadMessages + 1;
                    }
                  });
                  return unreadMessages == 0
                      ? Offstage()
                      : CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 10.5,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "$unreadMessages",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class UserTyping extends StatelessWidget {
  final Group group;
  final UserProfile user;
  const UserTyping({this.group, this.user});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('Typing')
          .document(group.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.data == null) {
          return RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: (group.fromName != user.name && group.fromName != '')
                      ? '${group.fromName}: '
                      : '',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${group.message}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        } else {
          String membername = snapshot.data.data['typing'];
          if (membername != null &&
              membername.isNotEmpty &&
              membername != user.name) {
            return Text(
              '$membername is typing',
              style: TextStyle(
                color: Colors.green,
                fontSize: 15.0,
              ),
            );
          }
        }
        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: (group.fromName != user.name && group.fromName != null)
                    ? '${group.fromName}: '
                    : '',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '${group.message}',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
