import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/use_cases/create_user.dart';
import '../../domain/use_cases/get_user.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(
      {required CreateUser createUser, required GetUser getUser})
      : _createUser = createUser,
        _getUser = getUser,
        super(const AuthenticationInitial());
  final CreateUser _createUser;
  final GetUser _getUser;

  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    emit(const CreatingUser());
    final result = await _createUser(
        CreateUserParams(createdAt: createdAt, name: name, avatar: avatar));
    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (_) => emit(const UserCreated()));
  }

  Future<void> getUsers() async {
    emit(const GettingUser());
    final result = await _getUser();
    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (user) => emit(UsersLoaded(user)));
  }
}
