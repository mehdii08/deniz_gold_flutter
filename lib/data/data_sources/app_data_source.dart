import 'package:deniz_gold/core/network/api_helper.dart';
import 'package:deniz_gold/core/utils/config.dart';
import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/data/dtos/balance_response_dto.dart';
import 'package:deniz_gold/data/dtos/check_active_trade_dto.dart';
import 'package:deniz_gold/data/dtos/check_mobile_exists_response_dto.dart';
import 'package:deniz_gold/data/dtos/coin_dto.dart';
import 'package:deniz_gold/data/dtos/coin_trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/coin_trade_submit_response_dto.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/data/dtos/havaleh_owner_dto.dart';
import 'package:deniz_gold/data/dtos/home_screen_data_dto.dart';
import 'package:deniz_gold/data/dtos/paginated_result_dto.dart';
import 'package:deniz_gold/data/dtos/phone_dto.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/data/dtos/transactions_result_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../dtos/coin_trade_dto.dart';
import '../dtos/coint_trades_detail_dto.dart';

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

  Future<CoinTradeDetailDTO> getCoinTradesDetail({
    required int id,
  });

  Future<PaginatedResultDTO<CoinTradeDTO>> getCoinTrades({
    required int page,
    int? tradeType,
    int? period,
  });

  Future<TradeDTO> checkTradeStatus({required int tradeId, required int needCancel});

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<HavaleDTO> storeHavale({
    required String value,
    required String name,
    required int? destination,
    required String fcmToken,
  });

  Future<List<CoinDTO>> getCoins();

  Future<CoinTradeCalculateResponseDTO> coinTradeCalculate({
    required Map<String, dynamic> body,
  });

  Future<CoinTradeSubmitResponseDTO> coinTradeSubmit({
    required Map<String, dynamic> body,
  });

  Future<TradeCalculateResponseDTO> tradeCalculate({
    required BuyAndSellType tradeType,
    required CalculateType calculateType,
    required String value,
  });

  Future<TradeSubmitResponseDTO> submitTrade({
    required BuyAndSellType tradeType,
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

  Future<BalanceResponseDTO> getBalance();

  Future<List<PhoneDTO>> getPhones();

  Future<List<HavalehOwnerDTO>> getHavalehOwnerList();

  Future<HomeScreenDataDTO> getHomeData();

  Future<TransactionsResultDTO> getTransactions({int page = 1});

  Future<PaginatedResultDTO<TradeDTO>> getTrades({
    required int page,
    int? tradeType,
    int? period,
  });

  Future<PaginatedResultDTO<HavaleDTO>> getHavales({required int page});

  Future<String> sendOTPCode({required String mobile});

  Future<CheckActiveTradeDTO> checkHasActiveTrade({required BuyAndSellType tradeType});
}

@LazySingleton(as: AppDataSource)
class AppDataSourceImpl extends AppDataSource {
  final ApiHelper _apiHelper;

  AppDataSourceImpl(this._apiHelper);

  @override
  Future<CheckMobileExistsResponseDTO> checkMobileExists({required String mobile}) async {
    final response =
        await _apiHelper.request('$apiPath/check-mobile-exists', method: Method.post, data: {'mobile': mobile});
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
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/profile/edit-password',
      method: Method.post,
      data: {
        'current_password': currentPassword,
        'password': newPassword,
      },
    );
    return response.data['message'];
  }

  @override
  Future<List<CoinDTO>> getCoins() async {
    final response = await _apiHelper.request('$apiPath/panel/coins/list');
    return List<CoinDTO>.from(response.dataAsMap()['coins'].map((e) => CoinDTO.fromJson(e)).toList());
  }

  @override
  Future<CoinTradeCalculateResponseDTO> coinTradeCalculate({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/coins/trade/calculate',
      method: Method.post,
      data: body,
    );
    return CoinTradeCalculateResponseDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<CoinTradeSubmitResponseDTO> coinTradeSubmit({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/coins/trade/submit',
      method: Method.post,
      data: body,
    );
    return CoinTradeSubmitResponseDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<HavaleDTO> storeHavale({
    required String value,
    required String name,
    required int? destination,
    required String fcmToken,
  }) async {
    final response = await _apiHelper.request(
      '$apiPath/panel/havaleh/store',
      method: Method.post,
      data: {
        'value': value,
        'name': name,
        'device_type': 3,
        'fcm_token': fcmToken,
        if (destination != null) 'destination_id': destination,
      },
    );
    return HavaleDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<TradeCalculateResponseDTO> tradeCalculate({
    required BuyAndSellType tradeType,
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
    required BuyAndSellType tradeType,
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
        requestId: response.dataAsMap()['request_id'],
        timeForCancel: response.dataAsMap()['time_for_cancel']);
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
  Future<BalanceResponseDTO> getBalance() async {
    final response = await _apiHelper.request('$apiPath/panel/get-balance');
    final result = BalanceResponseDTO.fromJson(response.dataAsMap());
    return result;
  }

  @override
  Future<List<PhoneDTO>> getPhones() async {
    final response = await _apiHelper.request('$apiPath/get-support-phones');
    return List<PhoneDTO>.from(response.dataAsMap()['phones'].map((e) => PhoneDTO.fromJson(e)).toList());
  }

  @override
  Future<List<HavalehOwnerDTO>> getHavalehOwnerList() async {
    final response = await _apiHelper.request('$apiPath/panel/havaleh/destinations');
    return List<HavalehOwnerDTO>.from(
        (response.data as Map<String, dynamic>)['data'].map((e) => HavalehOwnerDTO.fromJson(e)).toList());
  }

  @override
  Future<HomeScreenDataDTO> getHomeData() async {
    final response = await _apiHelper.request('$apiPath/panel/homepage');
    return HomeScreenDataDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<TransactionsResultDTO> getTransactions({int page = 1}) async {
    final response = await _apiHelper.request('$apiPath/panel/transactions?page=$page');
    return TransactionsResultDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<String> sendOTPCode({required String mobile}) async {
    final response = await _apiHelper
        .request(method: Method.post, '$apiPath/forget-password/send-otp-code', data: {'mobile': mobile});
    return response.data['message'];
  }

  @override
  Future<PaginatedResultDTO<TradeDTO>> getTrades({
    required int page,
    int? tradeType,
    int? period,
  }) async {
    final response = await _apiHelper.request(
        '$apiPath/panel/trades?page=$page${tradeType != null ? '&trade_type=$tradeType' : ''}${period != null ? '&period=$period' : ''}');
    final items = List<TradeDTO>.from(response.dataAsMap()['list']['data'].map((e) => TradeDTO.fromJson(e)).toList());
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
    final response = await _apiHelper.request('$apiPath/panel/havaleh?page=$page');
    final items = List<HavaleDTO>.from(response.dataAsMap()['list']['data'].map((e) => HavaleDTO.fromJson(e)).toList());
    return PaginatedResultDTO<HavaleDTO>(
      from: response.dataAsMap()['list']['from'] ?? 0,
      to: response.dataAsMap()['list']['to'] ?? 0,
      total: response.dataAsMap()['list']['total'] ?? 0,
      count: response.dataAsMap()['list']['count'] ?? 0,
      perPage: response.dataAsMap()['list']['per_page'] ?? 0,
      currentPage: response.dataAsMap()['list']['current_page'] ?? 0,
      lastPage: response.dataAsMap()['list']['last_page'] ?? false,
      items: items,
    );
  }

  @override
  Future<CheckActiveTradeDTO> checkHasActiveTrade({required BuyAndSellType tradeType}) async {
    final response =
        await _apiHelper.request('$apiPath/panel/trade/check-has-active-trade?trade_type=${tradeType.value}');
    return CheckActiveTradeDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<CoinTradeDetailDTO> getCoinTradesDetail({
    required int id,
  }) async {
    final response = await _apiHelper.request('$apiPath/panel/coins/trade-detail?trade_id=$id');
    return CoinTradeDetailDTO.fromJson(response.dataAsMap());
  }

  @override
  Future<PaginatedResultDTO<CoinTradeDTO>> getCoinTrades({
    required int page,
    int? tradeType,
    int? period,
  }) async {
    final params = {
      'page': page,
      if (tradeType != null) 'trade_type': tradeType,
      if (period != null) 'period': period,
    };
    final response = await _apiHelper.request('$apiPath/panel/coins/trades-list', queryParameters: params);
    final items =
        List<CoinTradeDTO>.from(response.dataAsMap()['list']['data'].map((e) => CoinTradeDTO.fromJson(e)).toList());
    return PaginatedResultDTO<CoinTradeDTO>(
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
  Future<TradeDTO> checkTradeStatus({required int tradeId, required int needCancel}) async {
    final response = await _apiHelper.request(
      method: Method.post,
      '$apiPath/panel/trade/cancel-request',
      data: {
        'id': tradeId,
        'need_cancel': needCancel,
      },
    );
    return TradeDTO.fromJson(response.dataAsMap());
  }
}

extension Responseee on Response<dynamic> {
  Map<String, dynamic> dataAsMap() => (data as Map<String, dynamic>)['data'];

  bool hasData() => data['data'] is Map<String, dynamic>;

  bool isSuccessFull() => (data as Map<String, dynamic>)['success'];
}
