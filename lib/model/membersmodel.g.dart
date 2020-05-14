// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membersmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MembersAdapter extends TypeAdapter<Members> {
  @override
  Members read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Members(
      members: (fields[0] as List)?.cast<Member>(),
    );
  }

  @override
  void write(BinaryWriter writer, Members obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.members);
  }

  @override
  int get typeId => 3;
}
