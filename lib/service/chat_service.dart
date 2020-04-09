import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class ChatServcice {
  static void chatWithAdmin({String userId}) async {
    try {
      Firestore.instance
          .collection(FirebaseUtils.chat)
          .document(userId)
          .setData({'user': userId});
    } catch (e) {
      print(e);
    }
  }

  // stream of user profile date
  StreamController<UserProfile> adminProfileStreamController =
      StreamController.broadcast();

  // fetch user data from the server
  void fetchAdminData() async {
    try {
      final querySnapshot = await FirebaseUtils.firestore
          .collection(FirebaseUtils.admin)
          .getDocuments();
      if (querySnapshot != null) {
        print('hello');
        final userProfile = UserProfile.fromMap(
          map: querySnapshot.documents[0].data,
        );
        adminProfileStreamController.add(userProfile); // add data to stream
      }
    } catch (e) {
      print(e);
    }
  }

// displose the stream
  void dispose() {
    adminProfileStreamController.close();
  }

  static Future<bool> sendMessage({ChatModel chat, String userId}) async {
    if (chat.message.isNotEmpty) {
      Firestore.instance
          .collection(FirebaseUtils.chat)
          .document(userId)
          .collection(FirebaseUtils.admin)
          .document()
          .setData(ChatModel.toMap(chat: chat));
      return true;
    }
    return false;
  }
}
