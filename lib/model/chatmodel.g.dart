// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  ChatModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      adminId: fields[2] as String,
      fromName: fields[8] as String,
      chatType: fields[3] as String,
      message: fields[4] as String,
      image: fields[5] as String,
      time: fields[6] as int,
      fromId: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.adminId)
      ..writeByte(3)
      ..write(obj.chatType)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.fromId)
      ..writeByte(8)
      ..write(obj.fromName);
  }

  @override
  int get typeId => 1;
}
