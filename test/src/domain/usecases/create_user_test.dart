// what does class depend upon
// Answer --> AuthenticationRepository
// How we can crate the mock version of the dependency
// Answer --> use MockTail
// How do we control what our dependency control
// Answer --> Use MockTail api's

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/domain/use_cases/create_user.dart';

import '../use_cases/authentication_repository.mock.dart';

void main() {
  late CreateUser useCase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    useCase = CreateUser(repository);
  });

  const params = CreateUserParams.empty();
  test('should call the [AuthenticationRepository.createUser]', () async {
    // Arrange
    when(() => repository.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar')))
        .thenAnswer((_) async => const Right(null));
    // Act
    final response = await useCase(params);
    // Assert

    expect(response, equals(const Right<dynamic, void>(null)));
    verify(() => repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar)).called(1);

    verifyNoMoreInteractions(repository);
  });
}
