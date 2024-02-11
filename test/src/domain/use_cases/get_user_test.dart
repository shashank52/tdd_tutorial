// what does class depend upon
// Answer --> AuthenticationRepository
// How we can crate the mock version of the dependency
// Answer --> use MockTail
// How do we control what our dependency control
// Answer --> Use MockTail api's

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/domain/entities/user.dart';
import 'package:tdd_tutorial/src/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/domain/use_cases/get_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late GetUser useCase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    useCase = GetUser(repository);
  });

  test(
      'should call the [AuthenticationRepository.getUser] and return List<User>',
      () async {
    // Arrange
    when(() => repository.getUser())
        .thenAnswer((_) async => const Right([User.empty()]));
    // Act
    final response = await useCase();
    // Assert

    expect(response, equals(const Right<dynamic, List<User>>([User.empty()])));
    verify(() => repository.getUser()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
