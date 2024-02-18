import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/error/failure.dart';
import 'package:tdd_tutorial/src/domain/entities/user.dart';
import 'package:tdd_tutorial/src/domain/use_cases/create_user.dart';
import 'package:tdd_tutorial/src/domain/use_cases/get_user.dart';
import 'package:tdd_tutorial/src/presentation/cubit/authentication_cubit.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUser extends Mock implements GetUser {}

void main() {
  late GetUser getUser;
  late CreateUser createUser;
  late AuthenticationCubit authCubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tUsers = [User.empty()];
  const tApiFailure = ApiFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUser = MockGetUser();
    createUser = MockCreateUser();
    authCubit = AuthenticationCubit(createUser: createUser, getUser: getUser);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => authCubit.close());

  test('initial state should be [AuthenticationInitial]', () async {
    expect(authCubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, UserCreated] when successful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Right(null));
          return authCubit;
        },
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        expect: () => [const CreatingUser(), const UserCreated()],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });
    blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, AuthenticationError] when unsuccessful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Left(tApiFailure));
          return authCubit;
        },
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        expect: () => [
              const CreatingUser(),
              AuthenticationError(tApiFailure.errorMessage)
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });
  });

  group('getUsers', () {
    blocTest('should emit [GettingUsers and UsersLoaded] when successful',
        build: () {
          when(() => getUser()).thenAnswer((_) async => const Right(tUsers));
          return authCubit;
        },
        act: (cubit) => {cubit.getUsers()},
        expect: () => [const GettingUser(), const UsersLoaded(tUsers)],
        verify: (_) {
          verify(() => getUser()).called(1);
          verifyNoMoreInteractions(getUser);
        });
    blocTest(
        'should emit [GettingUsers and AuthenticationError] when unsuccessful',
        build: () {
          when(() => getUser())
              .thenAnswer((_) async => const Left(tApiFailure));
          return authCubit;
        },
        act: (cubit) => {cubit.getUsers()},
        expect: () => [
              const GettingUser(),
              AuthenticationError(tApiFailure.errorMessage)
            ],
        verify: (_) {
          verify(() => getUser()).called(1);
          verifyNoMoreInteractions(getUser);
        });
  });
}
