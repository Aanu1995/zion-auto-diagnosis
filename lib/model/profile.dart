import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zion/service/notification_service.dart';

class UserProfile extends Equatable {
  final String name;
  final String email;
  final String profileURL;
  final String phoneNumber;
  final String address;
  final String notificationId;
  final bool online;
  final String id;
  final DateTime lastActive;

  UserProfile({
    this.name,
    this.email,
    this.id,
    this.profileURL,
    this.phoneNumber,
    this.address,
    this.online = true,
    this.lastActive,
    this.notificationId,
  });

  factory UserProfile.fromMap({@required Map map}) {
    DateTime dateTime;
    if (map['lastActive'] != null) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(map['lastActive']);
    }
    return UserProfile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileURL: map['profileURL'] ?? '',
      phoneNumber: map['phone'] ?? '',
      address: map['address'] ?? '',
      id: map['id'] ?? '',
      online: map['online'],
      lastActive: dateTime,
      notificationId: map['notificationId'],
    );
  }

  static Future<Map<String, dynamic>> toMap(
      {@required UserProfile user, String id}) async {
    // playerId (One signal notification)
    final playerId = await PushNotificationService.getPlayerId();
    return {
      'name': user.name.trim() ?? '',
      'email': user.email.trim() ?? '',
      'profileURL': user.profileURL ?? '',
      'phone': user.phoneNumber ?? '',
      'address': user.address ?? '',
      'online': user.online,
      'id': id,
      'lastActive': DateTime.now().millisecondsSinceEpoch,
      'notificationId': playerId ?? ''
    };
  }

  @override
  List<Object> get props =>
      [this.name, email, profileURL, phoneNumber, address, notificationId, id];
}
