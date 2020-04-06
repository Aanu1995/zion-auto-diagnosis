import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String profileURL;
  final String phoneNumber;

  UserProfile({
    this.name,
    this.email,
    this.profileURL,
    this.phoneNumber,
  });

  factory UserProfile.fromMap({@required Map<String, dynamic> map}) {
    return UserProfile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileURL: map['profileURL'] ?? '',
      phoneNumber: map['phone'] ?? '',
    );
  }

  static Map<String, dynamic> toMap({@required UserProfile user}) {
    return {
      'name': user.name.trim() ?? '',
      'email': user.email.trim() ?? '',
      'profileURL': user.profileURL.trim() ?? '',
      'phone': user.phoneNumber.trim() ?? '',
    };
  }
}
