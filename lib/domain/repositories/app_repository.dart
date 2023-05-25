import 'package:dartz/dartz.dart';
import 'package:deniz_gold/core/errors/failures.dart';
import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/data/dtos/balance_dto.dart';
import 'package:deniz_gold/data/dtos/check_active_trade_dto.dart';
import 'package:deniz_gold/data/dtos/check_mobile_exists_response_dto.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/data/dtos/home_screen_data_dto.dart';
import 'package:deniz_gold/data/dtos/paginated_result_dto.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/data/dtos/transaction_dto.dart';
import 'package:deniz_gold/data/enums.dart';

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

  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, String>> changePassword({
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, HavaleDTO>> storeHavale({
    required String value,
    required String name,
  });

  Future<Either<Failure, TradeCalculateResponseDTO>> tradeCalculate({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
  });

  Future<Either<Failure, TradeSubmitResponseDTO>> submitTrade({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
    required String fcmToken,
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

  Future<Either<Failure, AppConfigDTO>> getConfig();

  Future<Either<Failure, BalanceDTO>> getBalance();

  Future<Either<Failure, HomeScreenDataDTO>> getHomeData();

  Future<Either<Failure, List<TransactionDTO>>> getTransactions(
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
      {required TradeType tradeType});
}
