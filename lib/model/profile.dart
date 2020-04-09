import 'package:flutter/material.dart';
import 'package:zion/service/notification_service.dart';

class UserProfile {
  final String name;
  final String email;
  final String profileURL;
  final String phoneNumber;
  final String address;
  final String notificationId;

  UserProfile({
    this.name,
    this.email,
    this.profileURL,
    this.phoneNumber,
    this.address,
    this.notificationId,
  });

  factory UserProfile.fromMap({@required Map<String, dynamic> map}) {
    return UserProfile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileURL: map['profileURL'] ?? '',
      phoneNumber: map['phone'] ?? '',
      address: map['address'] ?? '',
      notificationId: map['notificationId'],
    );
  }

  static Future<Map<String, dynamic>> toMap(
      {@required UserProfile user}) async {
    // playerId (One signal notification)
    final playerId = await PushNotificationService.getPlayerId();
    return {
      'name': user.name.trim() ?? '',
      'email': user.email.trim() ?? '',
      'profileURL': user.profileURL ?? '',
      'phone': user.phoneNumber ?? '',
      'address': user.address ?? '',
      'notificationId': playerId ?? ''
    };
  }
}
