import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/provider/user_provider.dart';
import 'package:zion/views/components/custom_dialogs.dart';
import 'package:zion/views/utils/firebase_utils.dart';

class UserProfileService {
  static get initialData => UserProfile(
        name: "Anonymous",
        email: "example@gmail.com",
        phoneNumber: '08132363398',
        profileURL: "",
        address: "my address is in Nigeria",
      );
  // stream of user profile date
  StreamController<UserProfile> userProfileStreamController =
      StreamController.broadcast();

  // fetch user data from the server
  void fetchUserData() async {
    try {
      final user = await FirebaseUtils.auth.currentUser(); // get current user
      final documentSnapshot = await FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(user.uid)
          .get();
      if (documentSnapshot != null) {
        final userProfile = UserProfile.fromMap(map: documentSnapshot.data);
        userProfileStreamController.add(userProfile); // add data to stream
      }
    } catch (e) {
      print(e);
    }
  }

// displose the stream
  void dispose() {
    userProfileStreamController.close();
  }

  // upload user profile to the server
  static Future<String> uploadImage(
      final imageFile, BuildContext context) async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // sent images to firebase storage
      final storageReference = FirebaseUtils.storage
          .ref()
          .child(FirebaseUtils.profileImages)
          .child(user.uid)
          .child("profile.jpg");
      StorageUploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.onComplete;
      final String url = await storageReference.getDownloadURL();
      if (url != null) {
        // update the profile url in cloud firestore
        await FirebaseUtils.firestore
            .collection(FirebaseUtils.user)
            .document(user.uid)
            .updateData({FirebaseUtils.profileURL: url});
        // calls the function that gets user details data from server
        await Provider.of<UserProvider>(context, listen: false).getUserData();
        // return profile url
        return url;
      } else {
        // returns error
        return FirebaseUtils.error;
      }
    } catch (e) {
      // returns error
      return FirebaseUtils.error;
    }
  }

// delete user's profile image
  static deleteProfileImage(BuildContext context) async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // delete user data from the server
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(user.uid)
          .updateData({FirebaseUtils.profileURL: ''});
      // calls the function that gets user details data from server
      await Provider.of<UserProvider>(context, listen: false).getUserData();
      return "";
    } catch (e) {
      // returns error
      return FirebaseUtils.error;
    }
  }

  // edit user address
  static editAddress(String address, BuildContext context) async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // delete user data from the server
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(user.uid)
          .updateData({FirebaseUtils.address: address});
      // calls the function that gets user details data from server
      await Provider.of<UserProvider>(context, listen: false).getUserData();
    } catch (e) {
      // returns error
      CustomDialogs.showErroDialog(context, FirebaseUtils.error);
    }
  }

  // edit user address
  static editPhone(String phone, context) async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // delete user data from the server
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(user.uid)
          .updateData({FirebaseUtils.phone: phone});
      // calls the function that gets user details data from server
      await Provider.of<UserProvider>(context, listen: false).getUserData();
    } catch (e) {
      // returns error
      CustomDialogs.showErroDialog(context, FirebaseUtils.error);
    }
  }

  static setOnlineStatus() async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      if (user != null) {
        FirebaseDatabase.instance
            .reference()
            .child("/status/" + user.uid)
            .onDisconnect()
            .set("offline");

        FirebaseDatabase.instance
            .reference()
            .child("/status/" + user.uid)
            .set("online");
      }
    } catch (e) {
      print(e);
    }
  }

  static setUserOnline() async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      if (user != null) {
        await FirebaseUtils.firestore
            .collection(FirebaseUtils.user)
            .document(user.uid)
            .updateData({'online': true});
      }
    } catch (e) {
      print(e);
    }
  }
}
