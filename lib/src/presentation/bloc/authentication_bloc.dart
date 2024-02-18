import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/domain/entities/user.dart';
import 'package:tdd_tutorial/src/domain/use_cases/create_user.dart';
import 'package:tdd_tutorial/src/domain/use_cases/get_user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required CreateUser createUser, required GetUser getUser})
      : _createUser = createUser,
        _getUser = getUser,
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }
  final CreateUser _createUser;
  final GetUser _getUser;

  Future<void> _createUserHandler(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const CreatingUser());
    final result = await _createUser(CreateUserParams(
        createdAt: event.createdAt, name: event.name, avatar: event.avatar));
    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (_) => emit(const UserCreated()));
  }

  Future<void> _getUsersHandler(
      GetUsersEvent event, Emitter<AuthenticationState> emit) async {
    emit(const GettingUser());
    final result = await _getUser();
    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (user) => emit(UsersLoaded(user)));
  }
}
