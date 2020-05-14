// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupAdapter extends TypeAdapter<Group> {
  @override
  Group read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Group(
      id: fields[0] as String,
      adminId: fields[1] as String,
      adminName: fields[2] as String,
      fromName: fields[11] as String,
      createdAt: fields[3] as int,
      chatType: fields[6] as String,
      message: fields[7] as String,
      image: fields[8] as String,
      time: fields[9] as int,
      fromId: fields[10] as String,
      groupIcon: fields[4] as String,
      name: fields[5] as String,
      members: fields[12] as Members,
    );
  }

  @override
  void write(BinaryWriter writer, Group obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.adminId)
      ..writeByte(2)
      ..write(obj.adminName)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.groupIcon)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.chatType)
      ..writeByte(7)
      ..write(obj.message)
      ..writeByte(8)
      ..write(obj.image)
      ..writeByte(9)
      ..write(obj.time)
      ..writeByte(10)
      ..write(obj.fromId)
      ..writeByte(11)
      ..write(obj.fromName)
      ..writeByte(12)
      ..write(obj.members);
  }

  @override
  int get typeId => 2;
}
