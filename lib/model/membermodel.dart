import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'membermodel.g.dart';

@HiveType(typeId: 4, adapterName: "MemberAdapter")
class Member extends Equatable {
  @HiveField(0)
  String name;
  @HiveField(1)
  String id;

  Member({this.id, this.name}) : assert(name != null && id != null);

  factory Member.fromMap({Map<String, dynamic> map}) {
    return Member(name: map['name'], id: map['id']);
  }

  static Map<String, dynamic> toMap(Member member) {
    return {
      'name': member.name ?? '',
      'id': member.id ?? '',
    };
  }

  @override
  List<Object> get props => [name, id];
}
