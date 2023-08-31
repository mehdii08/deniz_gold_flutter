import 'dart:async';

import 'package:collection/collection.dart';
import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/data/dtos/coin_dto.dart';
import 'package:deniz_gold/data/dtos/coin_trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/coin_trade_submit_response_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:deniz_gold/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../app_config/app_config_cubit.dart';

part 'coin_shop_screen_state.dart';

@injectable
class CoinTabCubit extends Cubit<CoinTabState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;
  final Stream<AppNotificationEvent> appNotificationEvents;
  final _eventStreamController = StreamController<CoinTabEvent>();
  final _errorStreamController = StreamController<String>();

  Stream<CoinTabEvent> get eventStream => _eventStreamController.stream;

  Stream<String> get errorStream => _errorStreamController.stream;

  CoinTabCubit({
    required this.appRepository,
    required this.sharedPreferences,
    required this.appNotificationEvents,
  }) : super(const CoinTabState()) {
    tradeWaitingDialogIsOnTop = true;
    appNotificationEvents.listen((event) {
      if (event is CoinsPriceNotificationEvent) {
        emit(state.copyWith(coins: event.coins));
      }
    });
  }

  getData() async {
    emit(state.copyWith(isLoading: true));
    final result = await appRepository.getCoins();
    emit(state.copyWith(isLoading: false));
    result.fold(
      (l) {
        _errorStreamController.add(l.message ?? '');
      },
      (r) => emit(state.copyWith(coins: r)),
    );
  }

  @override
  Future<void> close() async {
    tradeWaitingDialogIsOnTop = false;
    return super.close();
  }

  increase({required int id}) {
    emit(state.increase(id: id));
  }

  decrease({required int id}) {
    emit(state.decrease(id: id));
  }

  bool cartIsEmpty() {
    return state.selectedCoins.fold(0, (sum, item) => sum + item.count) == 0;
  }

  int cartCount() {
    return state.selectedCoins.fold(0, (sum, item) => sum + item.count);
  }

  void calculate({required BuyAndSellType type}) async {
    if (!cartIsEmpty()) {
      final String fcmToken = sharedPreferences.getString(fcmTokenKey);
      emit(state.copyWith(buttonIsLoading: true));
      final body = {
        'type': type.value,
        'fcm_token': fcmToken,
        'coins': state.selectedCoins.map((e) => e.toJson()).toList(),
      };
      final response = await appRepository.coinTradeCalculate(body: body);
      emit(state.copyWith(buttonIsLoading: false));
      response.fold((l) {
        _errorStreamController.add(l.message ?? '');
      }, (r) {
        emit(state.copyWith(coinTradeCalculateResponseDTO: r));
        _eventStreamController.add(CoinTabEvent.showCalculateBottomSheet);
      });
    }
  }

  void submit({required BuyAndSellType type}) async {
    if (!cartIsEmpty()) {
      final String fcmToken = sharedPreferences.getString(fcmTokenKey);
      emit(state.copyWith(buttonIsLoading: true));
      final body = {
        'type': type.value,
        'fcm_token': fcmToken,
        'device_type': 3,
        'coins': state.selectedCoins.map((e) => e.toJson()).toList(),
      };
      final response = await appRepository.coinTradeSubmit(body: body);
      emit(state.copyWith(buttonIsLoading: false));
      response.fold((l) {
        _errorStreamController.add(l.message ?? '');
      }, (r) {
        emit(state.copyWith(coinTradeSubmitResponseDTO: r, selectedCoins: []));
        _eventStreamController.add(CoinTabEvent.showWaitingDialog);
      });
    }
  }
}

enum CoinTabEvent {
  showCalculateBottomSheet,
  showWaitingDialog,
  showResultDialog,
}
