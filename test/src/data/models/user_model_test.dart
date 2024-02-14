import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/data/models/user_model.dart';
import 'package:tdd_tutorial/src/domain/entities/user.dart';

import '../../../fixtures/fixtures_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test('should be subclass of [User] entity', () {
    //Arrange

    //Act

    //Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixtures('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with correct data', () {
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group('toJson', () {
    test('should return a [UserModel] with correct data', () {
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with correct data', () {
      // Arrange
      final result = tModel.toMap();
      // Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [Json] string with correct data', () {
      // Arrange
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": "1",
        "avatar": "_empty_avatar",
        "name": "_empty_name",
        "createdAt": "_empty_createdAt"
      });
      // Assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a modified [name]', () {
      // Arrange

      //Act
      final result = tModel.copyWith(name: 'Paul');
      //Assert
      expect(result.name, equals('Paul'));
    });
  });
}
