import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zion/views/screens/chat/components/zionchat/zion.dart';
import 'package:zion/views/utils/firebase_utils.dart';

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

// send input messages to the server
  static sendMessage({ChatMessage message, String userId}) {
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    try {
      Firestore.instance
          .collection(FirebaseUtils.chat)
          .document(userId)
          .collection(FirebaseUtils.admin)
          .document(createdAt.toString())
          .setData(
            message.toJson(createdAt),
          );
    } catch (e) {}
  }

  //update messageStatus to seen
  static updateMessageStatus({String userId, int status, String documentId}) {
    try {
      Firestore.instance
          .collection(FirebaseUtils.chat)
          .document(userId)
          .collection(FirebaseUtils.admin)
          .document(documentId)
          .updateData({'messageStatus': status});
    } catch (e) {}
  }

// send chat messages to the server
  static sendImage({File file, ChatUser user, String id}) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      StorageUploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.onComplete;
      final String url = await storageRef.getDownloadURL();
      ChatMessage message =
          ChatMessage(text: "", user: user, image: url, messageStatus: 0);
      sendMessage(message: message, userId: user.uid);
    } catch (e) {}
  }

  // load more messages for the chat
  static Future<List<DocumentSnapshot>> loadMoreMessages(
      String userId, DocumentSnapshot doc) async {
    List<DocumentSnapshot> list = [];
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(FirebaseUtils.chat)
          .document(userId)
          .collection(FirebaseUtils.admin)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(doc)
          .limit(20)
          .getDocuments();
      if (querySnapshot != null) {
        List<DocumentSnapshot> items = querySnapshot.documents;
        list = items;
      }
    } catch (e) {}
    return list;
  }
}
