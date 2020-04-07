import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUtils {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static Firestore get firestore => Firestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // database collection and document name
  // do not change, this will affect the backend
  static String get user => 'user';
  static String get profileImages => 'profileImages';
  static String get profileURL => 'profileURL';

  // this returns string result to data submitted to backend
  // results could be success or error
  static String get success => 'success';
  static String get error => 'Unknown error occured. Please try again!';
}
