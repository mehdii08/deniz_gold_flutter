import 'package:dartz/dartz.dart';
import 'package:deniz_gold/core/errors/failures.dart';
import 'package:deniz_gold/data/data_sources/app_data_source.dart';
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
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppRepository)
class AppRepositoryImpl extends AppRepository {
  final AppDataSource dataSource;

  AppRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, CheckMobileExistsResponseDTO>> checkMobileExists(
      {required String mobile}) async {
    try {
      return Right(await dataSource.checkMobileExists(mobile: mobile));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String code,
    required String mobile,
    required String name,
    required String nationalCode,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      return Right(await dataSource.register(
        code: code,
        mobile: mobile,
        name: name,
        nationalCode: nationalCode,
        password: password,
        passwordConfirmation: password,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String code,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      return Right(await dataSource.resetPassword(
        code: code,
        mobile: mobile,
        password: password,
        passwordConfirmation: password,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      return Right(await dataSource.changePassword(
        password: password,
        passwordConfirmation: password,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, HavaleDTO>> storeHavale({
    required String value,
    required String name,
  }) async {
    try {
      return Right(await dataSource.storeHavale(
        value: value,
        name: name,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, TradeCalculateResponseDTO>> tradeCalculate({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
  }) async {
    try {
      return Right(await dataSource.tradeCalculate(
        tradeType: tradeType,
        calculateType: calculateType,
        value: value,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, TradeSubmitResponseDTO>> submitTrade({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
    required String fcmToken,
  }) async {
    try {
      return Right(await dataSource.submitTrade(
        tradeType: tradeType,
        calculateType: calculateType,
        value: value,
        fcmToken: fcmToken,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfile({
    required String? name,
    required String? nationalCode,
  }) async {
    try {
      return Right(await dataSource.updateProfile(
        name: name,
        nationalCode: nationalCode,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> login({
    required String mobile,
    required String password,
  }) async {
    try {
      return Right(await dataSource.login(
        mobile: mobile,
        password: password,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, AppConfigDTO>> getConfig() async {
    try {
      return Right(await dataSource.getConfig());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, HomeScreenDataDTO>> getHomeData() async {
    try {
      return Right(await dataSource.getHomeData());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<TransactionDTO>>> getTransactions(
      {String count = "10"}) async {
    try {
      return Right(await dataSource.getTransactions(count: count));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedResultDTO<TradeDTO>>> getTrades(
      {required int page}) async {
    try {
      return Right(await dataSource.getTrades(page: page));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedResultDTO<HavaleDTO>>> getHavales(
      {required int page}) async {
    try {
      return Right(await dataSource.getHavales(page: page));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> sendOTPCode({required String mobile}) async {
    try {
      return Right(await dataSource.sendOTPCode(mobile: mobile));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CheckActiveTradeDTO>> checkHasActiveTrade(
      {required TradeType tradeType}) async {
    try {
      return Right(await dataSource.checkHasActiveTrade(tradeType: tradeType));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
