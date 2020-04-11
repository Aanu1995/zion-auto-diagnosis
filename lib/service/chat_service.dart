import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

// send input messages to the server
  static sendMessage({ChatMessage message, String userId}) {
    final documentReference = Firestore.instance
        .collection(FirebaseUtils.chat)
        .document(userId)
        .collection(FirebaseUtils.admin)
        .document(DateTime.now().millisecondsSinceEpoch.toString());
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

// send chat messages to the server
  static sendImage({File file, ChatUser user, String id}) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    StorageUploadTask uploadTask = storageRef.putFile(file);
    await uploadTask.onComplete;
    final String url = await storageRef.getDownloadURL();
    ChatMessage message = ChatMessage(text: "", user: user, image: url);
    sendMessage(message: message, userId: user.uid);
  }
}
