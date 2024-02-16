import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/core/error/failure.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/domain/entities/user.dart';
import 'package:tdd_tutorial/src/domain/repositories/authentication_repository.dart';

import '../data_sources/authentication_remote_data_source.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation(this._remoteDataSource);
  final AuthenticationRemoteDataSource _remoteDataSource;
  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUser() async {
    try {
      final result = await _remoteDataSource.getUser();
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
