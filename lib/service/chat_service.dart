import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zion/model/chatmodel.dart';
import 'package:zion/views/screens/chat/components/zionchat/zion.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class ChatServcice {
  // creates a chat id for the user and the admins
  static void chatWithAdmins({String userId}) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    try {
      final result = await Firestore.instance
          .collection(FirebaseUtils.admin)
          .getDocuments();
      for (int i = 0; i < result.documents.length; i++) {
        final adminId = result.documents[i].documentID;
        String chatId = userId + adminId;
        ChatModel chatModel =
            ChatModel(id: chatId, time: time, adminId: adminId, userId: userId);
        Firestore.instance
            .collection(FirebaseUtils.chats)
            .document(chatId)
            .setData(ChatModel.toMap(chatModel: chatModel));
        Firestore.instance
            .collection(FirebaseUtils.user)
            .document(userId)
            .collection(FirebaseUtils.groups)
            .document(chatId)
            .setData({
          'id': chatId,
          'time': time,
        });
        Firestore.instance
            .collection(FirebaseUtils.admin)
            .document(adminId)
            .collection(FirebaseUtils.groups)
            .document(chatId)
            .setData({
          'id': chatId,
          'time': time,
        });
      }
    } catch (e) {
      print(e);
    }
  }

// send input messages to the server
  static sendMessage({ChatMessage message, String chatId}) async {
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    try {
      final documentSnapshot =
          Firestore.instance.collection(FirebaseUtils.chats).document(chatId);
      await documentSnapshot
          .collection(FirebaseUtils.messages)
          .document(createdAt.toString())
          .setData(
            message.toJson(createdAt),
          );
      await documentSnapshot.updateData({
        'time': createdAt,
        'message': message.text,
        'from_id': message.user.uid,
        'from_name': message.user.name,
      });
    } catch (e) {}
  }

  //update messageStatus to seen
  static updateMessageStatus({String chatId, List<String> messagesId}) {
    try {
      final docRef =
          Firestore.instance.collection(FirebaseUtils.chats).document(chatId);
      Firestore.instance.runTransaction((transaction) async {
        messagesId.forEach((id) async {
          final doc = docRef.collection(FirebaseUtils.messages).document(id);
          await transaction.update(doc, {'messageStatus': 2});
        });
      });
    } catch (e) {}
  }

// send chat messages to the server
  static sendImage(
      {File file,
      ChatUser user,
      String chatId,
      int status,
      String text = ''}) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      StorageUploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.onComplete;
      final String url = await storageRef.getDownloadURL();
      ChatMessage message = ChatMessage(
          text: text, user: user, image: url, messageStatus: status);
      await sendMessage(message: message, chatId: chatId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // load more messages for the chat
  static Future<List<DocumentSnapshot>> loadMoreMessages(
      String chatId, DocumentSnapshot doc) async {
    List<DocumentSnapshot> list = [];
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(FirebaseUtils.chats)
          .document(chatId)
          .collection(FirebaseUtils.messages)
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

  // update the last time a message in a group is checked
  static void updateGroupCheckMessageTime(String userId, String groupId) {
    final lastSeen = DateTime.now().millisecondsSinceEpoch;
    try {
      Firestore.instance
          .collection(FirebaseUtils.user)
          .document(userId)
          .collection(FirebaseUtils.groups)
          .document(groupId)
          .updateData({'time': lastSeen});
    } catch (e) {}
  }

  // checks if user is typing
  static void isTyping(String chatId, {String username}) {
    Firestore.instance.collection('Typing').document(chatId).setData(
      {'typing': username ?? ""},
    );
  }
}
