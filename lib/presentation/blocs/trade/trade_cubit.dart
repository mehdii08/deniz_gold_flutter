import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:injectable/injectable.dart';

part 'trade_state.dart';

@injectable
class TradeCubit extends Cubit<TradeState> {
  final AppRepository appRepository;
  final Stream<AppNotificationEvent> appNotificationEvents;
  final SharedPreferencesRepository sharedPreferences;
  TradeType tradeType = TradeType.buy;

  TradeCubit({
    required this.appRepository,
    required this.appNotificationEvents,
    required this.sharedPreferences
  }) : super(const TradeInitial()){
    _checkHasActiveTrade(tradeType : tradeType);
   appNotificationEvents.listen((event) {
     if(event is TradeResultNotificationEvent){
       final condition = state is TradeSubmited
           && (state as TradeSubmited).data.requestId == event.requestId;
       if(condition){
         emit(TradeAnswerReached(
             status: event.status,
             totalPrice: event.totalPrice ?? "",
             mazaneh: event.mazaneh ?? "",
             weight: event.weight ?? "",
         ));
       }
     }
   });
  }

  changeTradeType(TradeType newTradeType){
    tradeType = newTradeType;
    _checkHasActiveTrade(tradeType : newTradeType);
  }

  _checkHasActiveTrade({required TradeType tradeType}) async {
    final result = await appRepository.checkHasActiveTrade(tradeType: tradeType);
    result.fold((l) {

    }, (r) {
      // if(r.hasActiveTrade && r.trade?.requestId != null){ //todo add requestId
      //   emit(TradeSubmited(message: Strings.youHaveActiveTrade, data : TradeSubmitResponseDTO(message: Strings.youHaveActiveTrade, requestId: r.trade!.requestId)));
      // }
    });
  }

  getTradeCalculateData({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
  }) async {
    emit(const TradeLoading(calculateLoading: true, submitLoading: false));
    final result = await appRepository.tradeCalculate(
      tradeType: tradeType,
      calculateType: calculateType,
      value: value,
    );
    result.fold(
      (l) => emit(TradeFailed(message: l.message != null ? l.message! : "")),
      (r) => emit(TradeCalculateLoaded(data: r)),
    );
  }

  submitTrade({
    required TradeType tradeType,
    required CalculateType calculateType,
    required String value,
  }) async {
    emit(const TradeLoading(calculateLoading: false, submitLoading: true));
    final String fcmToken = sharedPreferences.getString(fcmTokenKey);
    final result = await appRepository.submitTrade(
      tradeType: tradeType,
      calculateType: calculateType,
      value: value,
      fcmToken: fcmToken,
    );
    result.fold(
      (l) => emit(TradeFailed(message: l.message != null ? l.message! : "")),
      (r) => emit(TradeSubmited(message: r.message, data : r)),
    );
  }
}

// enum TradeType {
//   sell(0),
//   buy(1);
//
//   const TradeType(this.value);
//
//   final int value;
// }
//
// enum CalculateType {
//   weight(1),
//   toman(2);
//
//   const CalculateType(this.value);
//
//   final int value;
// }
