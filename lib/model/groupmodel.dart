import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:zion/model/membersmodel.dart';
import 'package:zion/views/utils/firebase_utils.dart';

part 'groupmodel.g.dart';

@HiveType(typeId: 2, adapterName: "GroupAdapter")
class Group extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String adminId;
  @HiveField(2)
  final String adminName;
  @HiveField(3)
  final int createdAt;
  @HiveField(4)
  final String groupIcon;
  @HiveField(5)
  final String name;
  @HiveField(6)
  final String chatType;
  @HiveField(7)
  final String message;
  @HiveField(8)
  final String image;
  @HiveField(9)
  final int time;
  @HiveField(10)
  final String fromId;
  @HiveField(11)
  final String fromName;
  @HiveField(12)
  final Members members;
  Group({
    this.id,
    this.adminId,
    this.adminName,
    this.fromName,
    this.createdAt,
    this.chatType,
    this.message,
    this.image,
    this.time,
    this.fromId,
    this.groupIcon,
    this.name,
    this.members,
  });

  factory Group.fromMap({
    Map<String, dynamic> map,
    Members members,
  }) {
    return Group(
      id: map['id'],
      adminId: map['admin_id'],
      adminName: map['admin_name'],
      groupIcon: map['group_icon'],
      name: map['name'],
      chatType: map['chat_type'],
      message: map['message'] ?? '',
      image: map['image'] ?? '',
      fromId: map['from_id'] ?? '',
      time: map['time'],
      members: members,
      fromName: map['from_name'],
      createdAt: map['createdAt'],
    );
  }

  static Map<String, dynamic> toMap({Group group}) {
    return {
      'id': group.id,
      'admin_id': group.adminId,
      'admin_name': group.adminName,
      'chat_type': FirebaseUtils.group,
      'message': group.message ?? '',
      'image': group.image ?? '',
      'from_id': group.fromId ?? '',
      'time': group.time,
      'name': group.name ?? '',
      'from_name': '',
      'group_icon': group.groupIcon,
      'createdAt': group.createdAt,
    };
  }

  @override
  List<Object> get props => [
        id,
        adminId,
        adminName,
        fromName,
        createdAt,
        groupIcon,
        chatType,
        message,
        image,
        fromId,
        time,
        name,
        members,
      ];
}
