import 'package:dartz/dartz.dart';
import 'package:deniz_gold/core/errors/failures.dart';
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
import 'package:deniz_gold/data/dtos/receipt_dto.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/data/dtos/transactions_result_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/dtos/coin_trade_dto.dart';
import '../../data/dtos/coint_trades_detail_dto.dart';

abstract class AppRepository {
  Future<Either<Failure, CheckMobileExistsResponseDTO>> checkMobileExists({
    required String mobile,
  });

  Future<Either<Failure, String>> register({
    required String token,
    required String mobile,
    required String name,
    required String nationalCode,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, CoinTradeDetailDTO>> getCoinTradesDetail({
    required int id,
  });

  Future<Either<Failure, PaginatedResultDTO<CoinTradeDTO>>> getCoinTrades({
    required int page,
    int? tradeType,
    int? period,
  });

  Future<Either<Failure, String>> setFish({
    required String name,
    required String trackingCode,
    required String price,
    required String fcmToken,
    required XFile file,
  });

  Future<Either<Failure, List<ReceiptDTO>>> getReceipt();

  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, HavaleDTO>> storeHavale({
    required String value,
    required String name,
    required int? destination,
    required int type,
    required String fcmToken,
  });

  Future<Either<Failure, TradeCalculateResponseDTO>> tradeCalculate({
    required BuyAndSellType tradeType,
    required CalculateType calculateType,
    required String value,
  });

  Future<Either<Failure, TradeSubmitResponseDTO>> submitTrade({
    required BuyAndSellType tradeType,
    required CalculateType calculateType,
    required String value,
    required String fcmToken,
  });

  Future<Either<Failure, TradeDTO>> checkTradeStatus({required int tradeId, required int needCancel});

  Future<Either<Failure, List<CoinDTO>>> getCoins();

  Future<Either<Failure, CoinTradeCalculateResponseDTO>> coinTradeCalculate({
    required Map<String,dynamic> body,
  });

  Future<Either<Failure, CoinTradeSubmitResponseDTO>> coinTradeSubmit({
    required Map<String,dynamic> body,
  });

  Future<Either<Failure, String>> updateName({required String name});

  Future<Either<Failure, String>> login({
    required String mobile,
    required String password,
  });

  Future<Either<Failure, String>> verifyMobile({
    required String mobile,
    required String code,
    required bool isRegister,
  });

  Future<Either<Failure, AppConfigDTO>> getConfig({required int currentVersion});

  Future<Either<Failure, BalanceResponseDTO>> getBalance();

  Future<Either<Failure, List<PhoneDTO>>> getPhones();

  Future<Either<Failure, List<HavalehOwnerDTO>>> getHavalehOwnerList();

  Future<Either<Failure, HomeScreenDataDTO>> getHomeData();

  Future<Either<Failure, TransactionsResultDTO>> getTransactions(
      {int page = 1});

  Future<Either<Failure, PaginatedResultDTO<TradeDTO>>> getTrades({
        required int page,
        int? tradeType,
        int? period,
      });

  Future<Either<Failure, PaginatedResultDTO<HavaleDTO>>> getHavales(
      {required int page});

  Future<Either<Failure, String>> sendOTPCode({required String mobile});

  Future<Either<Failure, CheckActiveTradeDTO>> checkHasActiveTrade(
      {required BuyAndSellType tradeType});
}
