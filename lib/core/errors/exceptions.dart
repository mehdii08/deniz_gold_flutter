import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:deniz_gold/presentation/strings.dart';

class AppException extends Equatable implements Exception {
  final String? message;

  const AppException({this.message});

  @override
  List<Object?> get props => [message];
}

class UnexpectedException extends AppException {
  const UnexpectedException()
      : super(message: Strings.unexpectedErrorHappened);
}

class NetworkException extends AppException {
  const NetworkException() : super(message: Strings.unexpectedErrorHappened);
}

class RequestCancelledException extends AppException {
  const RequestCancelledException()
      : super(message: Strings.unexpectedErrorHappened);
}

class CacheException extends AppException {
  const CacheException(): super(message: Strings.unexpectedErrorHappened);
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException._({required this.statusCode, required super.message});

  factory ServerException(
      {required int? statusCode,
        required String? message,
        required Response? response}) {
    switch (statusCode) {
      case 401:
        return UnAuthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 429:
        return RateLimitExceededException(
            message: message,
            rateLimitReset: num.tryParse(
                response?.headers.value('RateLimit-Reset') ?? '0') ??
                0);
    }
    return ServerException._(statusCode: statusCode, message: message);
  }

  @override
  List<Object?> get props => [statusCode, message];

  @override
  String toString() {
    return {'statusCode': statusCode, 'message': message}.toString();
  }
}

class UnAuthorizedException extends ServerException {
  const UnAuthorizedException(String? message)
      : super._(statusCode: 401, message: message);
}

class ForbiddenException extends ServerException {
  const ForbiddenException(String? message)
      : super._(statusCode: 403, message: message);
}

class RateLimitExceededException extends ServerException {
  final num rateLimitReset;

  const RateLimitExceededException(
      {required super.message, required this.rateLimitReset})
      : super._(statusCode: 429);
}