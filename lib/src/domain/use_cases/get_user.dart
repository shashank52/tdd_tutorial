import 'package:tdd_tutorial/core/use_case/use_case.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/domain/repositories/authentication_repository.dart';

import '../entities/user.dart';

class GetUser extends UseCaseWithoutParams<List<User>> {
  const GetUser(this._repository);

  final AuthenticationRepository _repository;
  @override
  ResultFuture<List<User>> call() => _repository.getUser();
}
