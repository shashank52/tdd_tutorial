import 'package:tdd_tutorial/core/utils/typedef.dart';

import '../entities/user.dart';

abstract class AuthenticationRepository {
  AuthenticationRepository();

  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar});

  ResultFuture<List<User>> getUser();
}
