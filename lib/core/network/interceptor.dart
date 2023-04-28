import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:gold_flutter/domain/repositories/shared_preferences_repository.dart';
// import 'package:gold_flutter/presentation/blocs/auth/authentication_cubit.dart';


//todo fix me
class AppInterceptor extends Interceptor {
  // final AuthenticationCubit authenticationCubit;
  // final SharedPreferencesRepository sharedPreferences;

  AppInterceptor(
      // {required this.authenticationCubit, required this.sharedPreferences}
      );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final String token = sharedPreferences.getString(authTokenKey);
    final String token = "sharedPreferences.getString(authTokenKey)";
    if (token.isNotEmpty) {
      final headers = <String, dynamic>{
        HttpHeaders.contentTypeHeader: 'application/json',
        // 'Authorization': "Bearer $token",
      };
      return handler.next(options..headers.addAll(headers));
    }
    final headers = <String, dynamic>{
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return handler.next(options..headers.addAll(headers));
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // if (_shouldSignOut(err) && authenticationCubit.isAuthenticated) {
    //   authenticationCubit.logOut();
    // }
    super.onError(err, handler);
  }

  bool _shouldSignOut(DioError err) =>
      err.response?.statusCode == 401 && err.response?.data?['errors']?.any((e) => e['code'] == 'UNAUTHORIZED');
}
