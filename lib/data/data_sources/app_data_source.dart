import 'package:deniz_gold/data/dtos/balance_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:dio/dio.dart';
import 'package:deniz_gold/core/network/api_helper.dart';
import 'package:deniz_gold/core/utils/config.dart';
import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/data/dtos/check_active_trade_dto.dart';
import 'package:deniz_gold/data/dtos/check_mobile_exists_response_dto.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/data/dtos/home_screen_data_dto.dart';
import 'package:deniz_gold/data/dtos/paginated_result_dto.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/data/dtos/transaction_dto.dart';
import 'package:injectable/injectable.dart';

abstract class AppDataSource {
  Future<CheckMobileExistsResponseDTO> checkMobileExists({
    required String mobile,
  });

  Future<String> register({
    required String token,
    required String mobile,
    required String name,
    required String nationalCode,
    required String password,
    required String passwordConfirmation,
  });

  Future<String> resetPassword({
    required String token,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  });

  Future<String> changePassword({
    required String password,
    required String passwordConfirmation,
  });

  Future<HavaleDTO> storeHavale({
    required String value,
    required String name,
  });

  Future<TradeCalculateResponseDTO> tradeCalculate({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
  });

  Future<TradeSubmitResponseDTO> submitTrade({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
    required String fcmToken,
  });

  Future<String> updateName({required String name});

  Future<String> login({
    required String mobile,
    required String password,
  });

  Future<String> verifyMobileRegister({
    required String mobile,
    required String code,
    required bool isRegister,
  });

  Future<AppConfigDTO> getConfig();

  Future<BalanceDTO> getBalance();

  Future<HomeScreenDataDTO> getHomeData();

  Future<List<TransactionDTO>> getTransactions({String count = "10"});

  Future<PaginatedResultDTO<TradeDTO>> getTrades({required int page});

  Future<PaginatedResultDTO<HavaleDTO>> getHavales({required int page});

  Future<String> sendOTPCode({required String mobile});

  Future<CheckActiveTradeDTO> checkHasActiveTrade(
      {required TradeType tradeType});
}

@LazySingleton(as: AppDataSource)
class AppDataSourceImpl extends AppDataSource {
  final ApiHelper _apiHelper;

  AppDataSourceImpl(this._apiHelper);

  @override
  Future<CheckMobileExistsResponseDTO> checkMobileExists(
      {required String mobile}) async {
    final response = await _apiHelper.request('$apiPath/check-mobile-exists',
        method: Method.post, data: {'mobile': mobile});
    return CheckMobileExistsResponseDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<String> register({
    required String token,
    required String mobile,
    required String name,
    required String nationalCode,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/register',
      method: Method.post,
      data: {
        'data_token': token,
        'mobile': mobile,
        'name': name,
        'national_code': nationalCode,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.dataAsMap()['token'];
  }

  @override
  Future<String> resetPassword({
    required String token,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/forget-password/update-password',
      method: Method.post,
      data: {
        'data_token': token,
        'mobile': mobile,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.data['message'];
  }

  @override
  Future<String> changePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/profile/edit-password',
      method: Method.post,
      data: {
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.data['message'];
  }

  @override
  Future<HavaleDTO> storeHavale({
    required String value,
    required String name,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/havaleh/store',
      method: Method.post,
      data: {
        'value': value,
        'name': name,
        'device_type': 3,
      },
    );
    return HavaleDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<TradeCalculateResponseDTO> tradeCalculate({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/trade/calculate',
      method: Method.post,
      data: {
        'trade_type': tradeType.value,
        'calculate_type': calculateType.value,
        'value': value,
      },
    );
    return TradeCalculateResponseDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<TradeSubmitResponseDTO> submitTrade({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
    required String fcmToken,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/trade/submit',
      method: Method.post,
      data: {
        'trade_type': tradeType.value,
        'calculate_type': calculateType.value,
        'value': value,
        'device_type': 3,
        'fcm_token': fcmToken,
      },
    );
    return TradeSubmitResponseDTO(
        message: response.data['message'],
        requestId: response.dataAsMap()['request_id']);
  }

  @override
  Future<String> updateName({required String name}) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/profile/edit-profile',
      method: Method.post,
      data: {'name': name},
    );
    return response.data['message'];
  }

  @override
  Future<String> login({
    required String mobile,
    required String password,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/login',
      method: Method.post,
      data: {
        'mobile': mobile,
        'password': password,
      },
    );
    return response.dataAsMap()['token'];
  }

  @override
  Future<String> verifyMobileRegister({
    required String mobile,
    required String code,
    required bool isRegister,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/${isRegister ? "register" : "forget-password"}/check-otp-code',
      method: Method.post,
      data: {
        'mobile': mobile,
        'code': code,
      },
    );
    return response.dataAsMap()['data_token'];
  }

  @override
  Future<AppConfigDTO> getConfig() async {
    final response = await _apiHelper.request('$apiPath/panel/get-config');
    final result = AppConfigDTO.fromJson(response.dataAsMap());
    return result;
  }

  @override
  Future<BalanceDTO> getBalance() async {
    final response = await _apiHelper.request('$apiPath/panel/get-balance');
    final result = BalanceDTO.fromJson(response.dataAsMap());
    return result;
  }

  @override
  Future<HomeScreenDataDTO> getHomeData() async {
    final response = await _apiHelper.request('$apiPath/panel/homepage');
    return HomeScreenDataDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<List<TransactionDTO>> getTransactions({String count = "10"}) async {
    final response =
        await _apiHelper.request('$apiPath/panel/transactions?count=$count');
    return List<TransactionDTO>.from(response
        .dataAsMap()['list']
        .map((e) => TransactionDTO.fromJson(e))
        .toList());
  }

  @override
  Future<String> sendOTPCode({required String mobile}) async {
    final response = await _apiHelper.request(
        method: Method.post,
        '$apiPath/forget-password/send-otp-code',
        data: {'mobile': mobile});
    return response.data['message'];
  }

  @override
  Future<PaginatedResultDTO<TradeDTO>> getTrades({required int page}) async {
    final response =
        await _apiHelper.request('$apiPath/panel/trades?page=$page');
    final items = List<TradeDTO>.from(response
        .dataAsMap()['list']['data']
        .map((e) => TradeDTO.fromJson(e))
        .toList());
    return PaginatedResultDTO<TradeDTO>(
      from: response.dataAsMap()['list']['from'] ?? 0,
      to: response.dataAsMap()['list']['to'] ?? 0,
      total: response.dataAsMap()['list']['total'],
      count: response.dataAsMap()['list']['count'],
      perPage: response.dataAsMap()['list']['per_page'],
      currentPage: response.dataAsMap()['list']['current_page'],
      lastPage: response.dataAsMap()['list']['last_page'],
      items: items,
    );
  }

  @override
  Future<PaginatedResultDTO<HavaleDTO>> getHavales({required int page}) async {
    final response =
        await _apiHelper.request('$apiPath/panel/havaleh?page=$page');
    final items = List<HavaleDTO>.from(response
        .dataAsMap()['list']['data']
        .map((e) => HavaleDTO.fromJson(e))
        .toList());
    return PaginatedResultDTO<HavaleDTO>(
      from: response.dataAsMap()['list']['from'],
      to: response.dataAsMap()['list']['to'],
      total: response.dataAsMap()['list']['total'],
      count: response.dataAsMap()['list']['count'],
      perPage: response.dataAsMap()['list']['per_page'],
      currentPage: response.dataAsMap()['list']['current_page'],
      lastPage: response.dataAsMap()['list']['last_page'],
      items: items,
    );
  }

  @override
  Future<CheckActiveTradeDTO> checkHasActiveTrade(
      {required TradeType tradeType}) async {
    final response = await _apiHelper.request(
        '$apiPath/panel/trade/check-has-active-trade?trade_type=${tradeType.value}');
    return CheckActiveTradeDTO.fromJson(response.dataAsMap());
  }
}

extension Responseee on Response<dynamic> {
  Map<String, dynamic> dataAsMap() => (data as Map<String, dynamic>)['data'];

  bool hasData() => data['data'] is Map<String, dynamic>;

  bool isSuccessFull() => (data as Map<String, dynamic>)['success'];
}
