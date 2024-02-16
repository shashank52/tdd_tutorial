import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/core/utils/app_endpoints.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/data/data_sources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    const String createdAt = 'createdAt';
    const String name = 'name';
    const String avatar = 'avatar';
    test('should complete successfully when status code is 200 or 201',
        () async {
      // Arrange
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User created successfully', 201));
      // Act

      final methodCall = remoteDataSource.createUser;
      expect(methodCall(createdAt: createdAt, name: name, avatar: avatar),
          completes);
      verify(() => client.post(Uri.https(kBaseUrl, kUserEndPoint),
              body: jsonEncode(
                  {'createdAt': createdAt, 'name': name, 'avatar': avatar})))
          .called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw [ApiException] when status code is not 200 or 201',
        () async {
      // Arrange
      when(() => client.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('Invalid Email address', 400));
      final methodCall = remoteDataSource.createUser;

      expect(
          () => methodCall(createdAt: createdAt, name: name, avatar: avatar),
          throwsA(const ApiException(
              serverMessage: 'Invalid Email address', statusCode: 400)));
      verify(() => client.post(Uri.https(kBaseUrl, kUserEndPoint),
              body: jsonEncode(
                  {'createdAt': createdAt, 'name': name, 'avatar': avatar})))
          .called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUser', () {
    final tUser = [const UserModel.empty()];
    test('should return [List<UserModel>] successfully when status code is 200',
        () async {
      //Arrange
      when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([tUser.first.toMap()]), 200));

      // Act
      final response = await remoteDataSource.getUser();
      // Assert

      expect(response, equals(tUser));

      verify(() => client.get(Uri.https(kBaseUrl, kGetUserEndPoint))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw an [ApiException] when status code is not 200',
        () async {
      //Arrange
      when(() => client.get(any()))
          .thenAnswer((_) async => http.Response('Unknown Error', 400));

      // Act
      final methodCall = remoteDataSource.getUser;
      // Assert

      expect(
          () => methodCall(),
          throwsA(const ApiException(
              serverMessage: 'Unknown Error', statusCode: 400)));

      verify(() => client.get(Uri.https(kBaseUrl, kGetUserEndPoint))).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
