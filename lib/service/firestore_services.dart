import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class FirestoreServices {
  static Stream<List<T>> collectionStream<T>({
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

  static Stream<List<String>> userGroupChatStream(String userId) =>
      collectionStream<String>(
        path: FirebaseUtils.firestore
            .collection(FirebaseUtils.user)
            .document(userId)
            .collection(FirebaseUtils.groups),
        builder: (data, documentId, docuements) => documentId,
      );

  static Stream<List<DocumentSnapshot>> chatStreams() =>
      collectionStream<DocumentSnapshot>(
        path: FirebaseUtils.firestore.collection(FirebaseUtils.chats),
        builder: (data, documentId, document) => document,
      );

  static Stream<List<AllChat>> allChatStream(String userId) {
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
          isGroup: chat.data['chat_type'] == FirebaseUtils.group ? true : false,
          time: chat.data['time'],
        ));
      });
      list.sort((a, b) => b.time.compareTo(a.time));
      return list;
    });
  }
}
