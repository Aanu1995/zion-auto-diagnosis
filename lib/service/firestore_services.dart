import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zion/model/allchats.dart';
import 'package:zion/model/chatmodel.dart';
import 'package:zion/model/groupmodel.dart';
import 'package:zion/views/utils/firebase_utils.dart';
import 'package:zion/views/utils/global_data_utils.dart';

class FirestoreServices {
  Stream<List<T>> collectionStream<T>({
    @required Query path,
    @required
        T builder(Map<String, dynamic> data, String documentID,
            DocumentSnapshot documents),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = path;
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map((snapshot) =>
              builder(snapshot.data, snapshot.documentID, snapshot))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<List<String>> userGroupChatStream(String userId) =>
      collectionStream<String>(
        path: FirebaseUtils.firestore
            .collection(FirebaseUtils.user)
            .document(userId)
            .collection(FirebaseUtils.groups),
        builder: (data, documentId, docuements) => documentId,
      );

  Stream<List<DocumentSnapshot>> chatStreams() =>
      collectionStream<DocumentSnapshot>(
        path: FirebaseUtils.firestore.collection(FirebaseUtils.chats),
        builder: (data, documentId, document) => document,
      );

  Stream<List<AllChat>> doubleChatStream(String userId) {
    try {
      return allChatStream(userId).asyncMap((allChats) async {
        List<AllChat> result = [];
        for (AllChat chat in allChats) {
          DocumentSnapshot groupDoc = await FirebaseUtils.firestore
              .collection(FirebaseUtils.user)
              .document(userId)
              .collection(FirebaseUtils.groups)
              .document(chat.isGroup ? chat.group.id : chat.oneone.id)
              .get();
          QuerySnapshot documents = await FirebaseUtils.firestore
              .collection(FirebaseUtils.chats)
              .document(chat.isGroup ? chat.group.id : chat.oneone.id)
              .collection(FirebaseUtils.messages)
              .where('messageStatus', isLessThan: 2)
              .getDocuments();
          int unreadMessages = 0;
          int lastSeen = groupDoc.data['time'];
          for (DocumentSnapshot search in documents.documents) {
            int messTime = int.parse(search.documentID);
            if (lastSeen < messTime) {
              unreadMessages = unreadMessages + 1;
            }
          }
          AllChat finalchat = chat;
          finalchat.unread = unreadMessages;
          result.add(finalchat);
        }
        var box = await Hive.openBox(GlobalDataUtils.zion);
        await box.put(FirebaseUtils.chats, result);
        return result;
      });
    } catch (e) {
      Hive.openBox(GlobalDataUtils.zion).then((box) async {
        List<AllChat> list = await box.get(FirebaseUtils.chats);
        return list;
      });
    }
    return null;
  }

  Stream<List<AllChat>> allChatStream(String userId) {
    try {
      return Rx.combineLatest2(userGroupChatStream(userId), chatStreams(),
          (List<String> groupChatId, List<DocumentSnapshot> chats) {
        List<AllChat> list = [];
        groupChatId.forEach((id) {
          final chat = chats?.firstWhere((chat) => chat.documentID == id,
              orElse: () => null);
          list.add(AllChat(
            group: chat.data['chat_type'] == FirebaseUtils.group
                ? Group.fromMap(map: chat.data)
                : null,
            oneone: chat.data['chat_type'] == FirebaseUtils.oneone
                ? ChatModel.fromMap(map: chat.data)
                : null,
            isGroup:
                chat.data['chat_type'] == FirebaseUtils.group ? true : false,
            time: chat.data['time'],
          ));
        });
        list.sort((a, b) => b.time.compareTo(a.time));
        return list;
      });
    } catch (e) {
      return null;
    }
  }
}
