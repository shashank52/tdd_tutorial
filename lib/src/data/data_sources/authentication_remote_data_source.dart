import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/data/models/user_model.dart';

import '../../../core/utils/app_endpoints.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});
  Future<List<UserModel>> getUser();
}

class AuthRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);
  final http.Client _client;
  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      final response = await _client.post(Uri.https(kBaseUrl, kUserEndPoint),
          body: jsonEncode({'createdAt': createdAt, 'name': name}),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
            serverMessage: response.body, statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(serverMessage: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUser() async {
    try {
      final response = await _client.get(Uri.https(kBaseUrl, kGetUserEndPoint));
      if (response.statusCode != 200) {
        throw ApiException(
            serverMessage: response.body, statusCode: response.statusCode);
      }
      return List<DataMap>.from(jsonDecode(response.body))
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(serverMessage: e.toString(), statusCode: 505);
    }
  }
}
