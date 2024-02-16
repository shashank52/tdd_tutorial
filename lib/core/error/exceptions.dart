import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException(
      {required this.serverMessage, required this.statusCode});

  final String serverMessage;
  final int statusCode;

  @override
  List<Object?> get props => [serverMessage, statusCode];
}

class ApiException extends ServerException {
  const ApiException({required super.serverMessage, required super.statusCode});
}
