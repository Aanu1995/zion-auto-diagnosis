import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class ChatStreams {
  Stream<QuerySnapshot> allChatsStream =
      FirebaseUtils.firestore.collection(FirebaseUtils.admin).snapshots();
}
