import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/src/data/data_sources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/domain/use_cases/create_user.dart';
import 'package:tdd_tutorial/src/domain/use_cases/get_user.dart';
import 'package:tdd_tutorial/src/presentation/cubit/authentication_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App Logic
    ..registerFactory(
        () => AuthenticationCubit(createUser: sl(), getUser: sl()))
    // Use Cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUser(sl()))
    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))
    // Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()))
    // External Dependencies
    ..registerLazySingleton(http.Client.new);
}
