import 'dart:async';
import 'package:zion/model/profile.dart';
import 'package:zion/user_inteface/utils/firebase_utils.dart';

class UserProfileService {
  static get initialData => UserProfile(
        name: "Anonymous",
        email: "example@gmail.com",
        phoneNumber: '08132363398',
        profileURL: "",
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

  static void dispose() {
    userProfileStreamController.close();
  }
}
