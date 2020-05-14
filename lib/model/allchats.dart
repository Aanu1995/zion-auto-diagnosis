import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:zion/model/chatmodel.dart';
import 'package:zion/model/groupmodel.dart';

part 'allchats.g.dart';

@HiveType(typeId: 0, adapterName: "AllchatAdapter")
class AllChat extends Equatable {
  @HiveField(0)
  final Group group;
  @HiveField(1)
  final ChatModel oneone;
  @HiveField(2)
  final bool isGroup;
  @HiveField(3)
  final int time;
  @HiveField(4)
  int unread;
  @HiveField(5)
  int totalUnread;

  AllChat(
      {this.group,
      this.oneone,
      this.isGroup,
      this.time,
      this.unread = 0,
      this.totalUnread});

  @override
  List<Object> get props => [group, oneone, isGroup, unread];
}
