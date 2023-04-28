import 'package:equatable/equatable.dart';
import 'package:deniz_gold/core/errors/exceptions.dart';

class Failure extends Equatable {
  final String? message;

  const Failure._({this.message});

  factory Failure.fromException(Exception exception) {
    if (exception is RequestCancelledException) {
      return RequestCancelledFailure(message: exception.message);
    }
    if (exception is ForbiddenException) {
      return ForbiddenFailure(message: exception.message);
    }
    if (exception is NetworkException) {
      return const NetworkFailure();
    }
    if (exception is ServerException) {
      return ServerFailure.fromException(exception);
    }
    if (exception is AppException) {
      return Failure._(
          message: exception.message);
    }
    // TODO: should change the message
    return const Failure._(
        message: 'Failure');
  }

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super._(message: 'NetworkFailure');
}

class ServerFailure extends Failure {
  const ServerFailure({super.message}) : super._();

  factory ServerFailure.fromException(ServerException exception) {
    if (exception is RateLimitExceededException) {
      return RateLimitExceededFailure(
          rateLimitReset: exception.rateLimitReset, message: exception.message);
    }
    if (exception is ForbiddenException) {
      return ForbiddenFailure(message: exception.message);
    }
    if (exception is UnAuthorizedException) {
      return UnAuthorizedFailure(message: exception.message);
    }
    return ServerFailure(message: exception.message);
  }
}

class CacheFailure extends Failure {
  const CacheFailure() : super._(message: '');
}

class ForbiddenFailure extends ServerFailure {
  const ForbiddenFailure({super.message});
}

class UnAuthorizedFailure extends ServerFailure {
  const UnAuthorizedFailure({super.message});
}

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure({super.message}) : super._();
}

class RateLimitExceededFailure extends ServerFailure {
  final num rateLimitReset;

  const RateLimitExceededFailure({super.message, required this.rateLimitReset});
}

class FileDoesNotExistFailure extends Failure {
  final String? fileId;

  const FileDoesNotExistFailure(this.fileId) : super._(message: '');

  @override
  List<Object?> get props => [fileId];
}
