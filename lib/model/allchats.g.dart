// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allchats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllchatAdapter extends TypeAdapter<AllChat> {
  @override
  AllChat read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllChat(
      group: fields[0] as Group,
      oneone: fields[1] as ChatModel,
      isGroup: fields[2] as bool,
      time: fields[3] as int,
      unread: fields[4] as int,
      totalUnread: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AllChat obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.group)
      ..writeByte(1)
      ..write(obj.oneone)
      ..writeByte(2)
      ..write(obj.isGroup)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.unread)
      ..writeByte(5)
      ..write(obj.totalUnread);
  }

  @override
  int get typeId => 0;
}
