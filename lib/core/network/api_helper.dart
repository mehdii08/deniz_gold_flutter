import 'dart:io';

import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:dio/dio.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:injectable/injectable.dart';
import 'package:deniz_gold/core/errors/exceptions.dart';

enum Method { get, post, put, delete, update, patch }

extension MathodName on Method {
  String get name {
    switch (this) {
      case Method.get:
        return 'GET';
      case Method.post:
        return 'POST';
      case Method.update:
        return 'UPDATE';
      case Method.delete:
        return 'DELETE';
      case Method.put:
        return 'PUT';
      case Method.patch:
        return 'PATCH';
    }
  }
}

typedef Request = Future<Response> Function();

@lazySingleton
class ApiHelper {
  final Dio dio;
  final AuthenticationCubit authenticationCubit;

  ApiHelper({required this.dio, required this.authenticationCubit});

  Future<Response> request(
    String path, {
    Method method = Method.get,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    Future<Response> request() => dio.request(
          path,
          options: Options(
            method: method.name,
            followRedirects: false,
            validateStatus: (status) => true,
          ),
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );
    return await _handleErrorAndGetResponse(request);
  }

  Future<Response> uploadImage( String path,FormData formData) async {

    Future<Response> request()=>dio.request(path, data: formData,
        options:Options(
          method: Method.post.name,
          followRedirects: false,
          validateStatus: (status) => true,
        ) );
    return await _handleErrorAndGetResponse(request);

  }

  Future<Response> _handleErrorAndGetResponse(Request request) async {
    try {
      final result = await request();
      if (result.statusCode != null && result.statusCode! >= 300) {
        final userStatus =
            result.hasData() ? result.dataAsMap()['user']['status_code'] : null;
        if (result.statusCode == HttpStatus.unauthorized) {
          authenticationCubit.logOut();
          final message = result.data?['message'] ?? Strings.unKnownError;
          throw UnAuthorizedException(message);
        } else if (userStatus != null && userStatus == 2 || userStatus == "2") {
          authenticationCubit.logOut();
          final message = result.data?['message'] ?? Strings.unKnownError;
          throw UnAuthorizedException(message);
        } else {
          final message = result.data?['message'] ?? "error";
          throw ServerException(
              statusCode: result.statusCode,
              message: message,
              response: result);
        }
      }
      return result;
    } on DioError catch (e) {
      if (e.type == DioErrorType.badResponse && e.response?.data is Map) {
        final response = e.response;
        final message = response?.data['message'];
        throw ServerException(
          statusCode: response?.statusCode,
          message: message,
          response: response,
        );
      }
      if (e.type == DioErrorType.cancel) {
        throw const RequestCancelledException();
      }
      if (e.type.isTimeout) {
        throw const NetworkException();
      }
      throw const UnexpectedException();
    }
  }
}

extension on DioErrorType {
  bool get isTimeout =>
      this == DioErrorType.connectionTimeout ||
      this == DioErrorType.receiveTimeout ||
      this == DioErrorType.sendTimeout;
}
