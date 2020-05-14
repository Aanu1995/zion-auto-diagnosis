import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:zion/model/membersmodel.dart';
import 'package:zion/views/utils/firebase_utils.dart';

part 'chatmodel.g.dart';

@HiveType(typeId: 1, adapterName: "ChatModelAdapter")
class ChatModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String adminId;
  @HiveField(3)
  final String chatType;
  @HiveField(4)
  final String message;
  @HiveField(5)
  final String image;
  @HiveField(6)
  final int time;
  @HiveField(7)
  final String fromId;
  @HiveField(8)
  final String fromName;

  ChatModel({
    this.id,
    this.userId,
    this.adminId,
    this.fromName,
    this.chatType,
    this.message,
    this.image,
    this.time,
    this.fromId,
  });

  factory ChatModel.fromMap({
    Map<String, dynamic> map,
    Members members,
  }) {
    return ChatModel(
      id: map['id'],
      userId: map['userId'],
      adminId: map['adminId'],
      chatType: map['chat_type'],
      message: map['message'] ?? '',
      image: map['image'] ?? '',
      fromId: map['from_id'] ?? '',
      time: map['time'],
      fromName: map['from_name'],
    );
  }

  static Map<String, dynamic> toMap({ChatModel chatModel}) {
    return {
      'id': chatModel.id,
      'userId': chatModel.userId,
      'adminId': chatModel.adminId,
      'chat_type': FirebaseUtils.oneone,
      'message': chatModel.message ?? '',
      'image': chatModel.image ?? '',
      'from_id': chatModel.fromId ?? '',
      'time': chatModel.time,
      'from_name': '',
    };
  }

  @override
  List<Object> get props => [
        id,
        userId,
        adminId,
        chatType,
        message,
        image,
        time,
        fromId,
      ];
}
