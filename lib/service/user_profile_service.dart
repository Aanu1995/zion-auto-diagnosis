import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class UserProfileService {
  static get initialData => UserProfile(
        name: "Anonymous",
        email: "example@gmail.com",
        phoneNumber: '08132363398',
        profileURL: "",
        address: "my address is in Nigeria",
      );
  // stream of user profile date
  static StreamController<UserProfile> userProfileStreamController =
      StreamController.broadcast();

  // fetch user data from the server
  static void fetchUserData() async {
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
  static void dispose() {
    userProfileStreamController.close();
  }

  // upload user profile to the server
  static Future<String> uploadImage(final imageFile) async {
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
        UserProfileService.fetchUserData();
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

  static deleteProfileImage() async {
    try {
      // gets userid
      final user = await FirebaseUtils.auth.currentUser();
      // delete user data from the server
      await FirebaseUtils.firestore
          .collection(FirebaseUtils.user)
          .document(user.uid)
          .updateData({FirebaseUtils.profileURL: ''});
      // calls the function that gets user details data from server
      UserProfileService.fetchUserData();
      return "";
    } catch (e) {
      // returns error
      return FirebaseUtils.error;
    }
  }
}
