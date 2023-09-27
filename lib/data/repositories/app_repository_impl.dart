import 'package:dartz/dartz.dart';
import 'package:deniz_gold/core/errors/failures.dart';
import 'package:deniz_gold/data/data_sources/app_data_source.dart';
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
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../dtos/coin_trade_dto.dart';
import '../dtos/coint_trades_detail_dto.dart';

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
    required String token,
    required String mobile,
    required String name,
    required String nationalCode,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      return Right(await dataSource.register(
        token: token,
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
  Future<Either<Failure, List<ReceiptDTO>>> getReceipt() async {
    try {
      return Right(await dataSource.getReceipt());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> setFish({
    required String name,
    required String trackingCode,
    required String price,
    required String fcmToken,
    required XFile file,
  }) async {
    try {
      return Right(await dataSource.sendFish(
        name: name,
        trackingCode: trackingCode,
        price: price,
        fcmToken: fcmToken,
        file: file,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
  @override
  Future<Either<Failure, CoinTradeDetailDTO>> getCoinTradesDetail({
    required int id,
  }) async {
    try {
      return Right(await dataSource.getCoinTradesDetail(
        id: id,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedResultDTO<CoinTradeDTO>>> getCoinTrades({
    required int page,
    int? tradeType,
    int? period,
  }) async {
    try {
      return Right(await dataSource.getCoinTrades(
        page: page,
        tradeType: tradeType,
        period: period,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, TradeDTO>> checkTradeStatus({required int tradeId, required int needCancel}) async {
    try {
      return Right(await dataSource.checkTradeStatus(tradeId: tradeId, needCancel: needCancel));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      return Right(await dataSource.resetPassword(
        token: token,
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
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      return Right(await dataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, HavaleDTO>> storeHavale({
    required String value,
    required String name,
    required int? destination,
    required int type,
    required String fcmToken,
  }) async {
    try {
      return Right(await dataSource.storeHavale(
        value: value,
        name: name,
        destination : destination,
        type: type,
        fcmToken : fcmToken,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CoinDTO>>> getCoins() async {
    try {
      return Right(await dataSource.getCoins());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CoinTradeCalculateResponseDTO>> coinTradeCalculate({
    required Map<String,dynamic> body,
  }) async {
    try {
      return Right(await dataSource.coinTradeCalculate(
        body: body,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CoinTradeSubmitResponseDTO>> coinTradeSubmit({
    required Map<String,dynamic> body,
  }) async {
    try {
      return Right(await dataSource.coinTradeSubmit(
        body: body,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, TradeCalculateResponseDTO>> tradeCalculate({
    required BuyAndSellType tradeType,
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
    required BuyAndSellType tradeType,
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
  Future<Either<Failure, String>> updateName({required String name}) async {
    try {
      return Right(await dataSource.updateName(name: name));
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
  Future<Either<Failure, String>> verifyMobile({
    required String mobile,
    required String code,
    required bool isRegister,
  }) async {
    try {
      return Right(await dataSource.verifyMobileRegister(
        mobile: mobile,
        code: code,
          isRegister : isRegister,
      ));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, AppConfigDTO>> getConfig({required int currentVersion}) async {
    try {
      return Right(await dataSource.getConfig(currentVersion: currentVersion));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, BalanceResponseDTO>> getBalance() async {
    try {
      return Right(await dataSource.getBalance());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<PhoneDTO>>> getPhones() async {
    try {
      return Right(await dataSource.getPhones());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<HavalehOwnerDTO>>> getHavalehOwnerList() async {
    try {
      return Right(await dataSource.getHavalehOwnerList());
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
  Future<Either<Failure, TransactionsResultDTO>> getTransactions(
      {int page = 1}) async {
    try {
      return Right(await dataSource.getTransactions(page: page));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedResultDTO<TradeDTO>>> getTrades({
    required int page,
    int? tradeType,
    int? period,
  }) async {
    try {
      return Right(await dataSource.getTrades(
          page: page,
          tradeType: tradeType,
          period: period,
      ));
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
      {required BuyAndSellType tradeType}) async {
    try {
      return Right(await dataSource.checkHasActiveTrade(tradeType: tradeType));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
