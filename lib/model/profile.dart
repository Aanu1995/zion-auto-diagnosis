import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String profileURL;
  final String phoneNumber;
  final String address;

  UserProfile({
    this.name,
    this.email,
    this.profileURL,
    this.phoneNumber,
    this.address,
  });

  factory UserProfile.fromMap({@required Map<String, dynamic> map}) {
    return UserProfile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileURL: map['profileURL'] ?? '',
      phoneNumber: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  static Map<String, dynamic> toMap({@required UserProfile user}) {
    return {
      'name': user.name.trim() ?? '',
      'email': user.email.trim() ?? '',
      'profileURL': user.profileURL ?? '',
      'phone': user.phoneNumber ?? '',
      'address': user.address ?? '',
    };
  }
}
