import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:zion/model/membermodel.dart';

part 'membersmodel.g.dart';

@HiveType(typeId: 3, adapterName: "MembersAdapter")
class Members extends Equatable {
  @HiveField(0)
  List<Member> members;
  Members({this.members});

  @override
  List<Object> get props => [members];
}
