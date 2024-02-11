import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/use_case/use_case.dart';
import 'package:tdd_tutorial/src/domain/repositories/authentication_repository.dart';

import '../../../core/utils/typedef.dart';

class CreateUser extends UseCaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultVoid call(CreateUserParams params) async => _repository.createUser(
      createdAt: params.createdAt, name: params.name, avatar: params.avatar);
}

class CreateUserParams extends Equatable {
  const CreateUserParams(
      {required this.createdAt, required this.name, required this.avatar});

  const CreateUserParams.empty()
      : this(
            createdAt: '_empty_createdAt',
            name: '_empty_name',
            avatar: '_empty_avatar');
  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
