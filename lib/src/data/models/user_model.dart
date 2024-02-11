import 'dart:convert';

import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.avatar,
      required super.createdAt,
      required super.name,
      required super.id});
  factory UserModel.fromJson(String dataSource) =>
      UserModel.fromMap(jsonDecode(dataSource));
  UserModel.fromMap(DataMap map)
      : this(
            avatar: map['avatar'] as String,
            id: map['id'] as String,
            name: map['name'] as String,
            createdAt: map['createdAt'] as String);
  UserModel copyWith(
      {String? id, String? name, String? createdAt, String? avatar}) {
    return UserModel(
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name,
        id: id ?? this.id);
  }

  DataMap toMap() =>
      {'id': id, 'avatar': avatar, 'name': name, 'createdAt': createdAt};
  String toJson() => jsonEncode(toMap());
}
