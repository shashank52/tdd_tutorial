import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/core/error/failure.dart';
import 'package:tdd_tutorial/src/data/data_sources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/data/repositories/authentication_repository_implementation.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSrc;
  late AuthenticationRepositoryImplementation repoImpl;
  setUp(() {
    remoteDataSrc = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSrc);
  });

  const tException =
      ApiException(serverMessage: 'Unknown Error Occurred', statusCode: 500);

  group('createUser', () {
    const createdAt = 'createdAt';
    const name = "name";
    const avatar = 'avatar';
    test(
        'should call the [RemoteDataSource.createUser] with successful response',
        () async {
      //arrange
      when(() => remoteDataSrc.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repoImpl.createUser(
          avatar: avatar, createdAt: createdAt, name: name);
      // assert
      expect(result, equals(const Right(null)));
      verify(() => remoteDataSrc.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should return [APIFailure] when the call is unsuccessful', () async {
      // Arrange
      when(() => {
            remoteDataSrc.createUser(
                createdAt: any(named: 'createdAt'),
                name: any(named: 'name'),
                avatar: any(named: 'avatar'))
          }).thenThrow(tException);
      // Act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      expect(
          result,
          equals(Left(ApiFailure(
              message: tException.serverMessage,
              statusCode: tException.statusCode))));
      verify(() => remoteDataSrc.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('getUser', () {
    // test('should call the [RemoteDataSource.getUser] with successful response',
    //     () async {
    //   // Arrange
    //   when(() => {remoteDataSrc.getUser()}).thenAnswer((_)  => []);
    //   // Act
    //   final result = await repoImpl.getUser();
    //   // Assert
    //   expect(result, equals(const Right([UserModel.empty()])));
    //   verify(() => remoteDataSrc.getUser()).called(1);
    //   verifyNoMoreInteractions(remoteDataSrc);
    // });

    test('should return [APIFailure] when the call is unsuccessful', () async {
      //Arrange
      when(() => {remoteDataSrc.getUser()}).thenThrow(tException);

      // Act
      final result = await repoImpl.getUser();
      //Assert

      expect(
          result,
          equals(Left(ApiFailure(
              message: tException.serverMessage,
              statusCode: tException.statusCode))));
      verify(() => remoteDataSrc.getUser()).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });
}
