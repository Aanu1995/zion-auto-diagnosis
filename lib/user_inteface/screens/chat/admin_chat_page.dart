import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/chat/components/message_inputbox.dart';
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
  ScrollController _controller = ScrollController();
  String text;
  bool lastSeen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection(FirebaseUtils.chat)
                    .document(widget.userId)
                    .collection(FirebaseUtils.admin)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // this sets the values to default when the list rebuilds
                  //lastSeen = false;
                  //text = null;
                  if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.hasData) {
                    List<ChatModel> list = ChatModel.fromQuerySnapshot(
                        querySnapshot: snapshot.data);
                    return ListView(
                      controller: _controller,
                      padding: EdgeInsets.only(bottom: 16.0),
                      reverse: true,
                      children: <Widget>[
                        for (int index = 0; index < list.length; index++)
                          ChatBox(chatModel: list[index]),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
            MyTextField(userId: widget.userId),
          ],
        ),
      ),
    );
  }
/* 
  bool aDayAgo(int index, List list) {
    int day = DateTime.now().difference(list[index].dateTime).inDays;
    if (day >= 1 && day < 2) {
      return true;
    } else {
      return false;
    }
  }

  bool toDay(int index, List list) {
    int hours = DateTime.now().difference(list[index].dateTime).inHours;
    if (hours < 24) {
      return true;
    } else {
      return false;
    }
  }

  String formatMyDate(int index, List list) {
    int day = DateTime.now().difference(list[index].dateTime).inDays;
    if (day >= 2) {
      var format = DateFormat.yMMMMd('en_US');
      var correctDate = format.format(list[index].dateTime);
      return correctDate;
    } else {
      return null;
    }
  }

  structureMyDate(int index, List list) {
    lastSeen = false;
    String anyDate = formatMyDate(index, list);
    if (text != anyDate && anyDate != null) {
      text = anyDate;
      lastSeen = true;
    } else if (aDayAgo(index, list) && text != "Yesterday") {
      text = "Yesterday";
      lastSeen = true;
    } else if (toDay(index, list) && text != "Today") {
      text = "Today";
      lastSeen = true;
    }
  } */
}

class ChatBox extends StatelessWidget {
  final ChatModel chatModel;
  const ChatBox({this.chatModel});
  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: BubbleEdges.only(
          top: 12,
          left: chatModel.isUser ? 50.0 : 0.0,
          right: chatModel.isUser ? 0.0 : 50.0),
      padding: BubbleEdges.all(8.0),
      alignment: chatModel.isUser ? Alignment.topRight : Alignment.topLeft,
      nip: chatModel.isUser ? BubbleNip.rightTop : BubbleNip.leftTop,
      color:
          chatModel.isUser ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: <Widget>[
              if (chatModel.image.isNotEmpty)
                Container(), // Todo will be handled later
              if (chatModel.audio.isNotEmpty)
                Container(), // Todo will be handled later
              if (chatModel.message.isNotEmpty)
                Text(
                  chatModel.message,
                  style: TextStyle(fontSize: 15.5),
                ),
            ],
          ),
          SizedBox(height: 5.0),
          Text(
            chatModel.time,
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
