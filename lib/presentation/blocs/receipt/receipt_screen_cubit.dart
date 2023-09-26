import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/receipt_dto.dart';
import 'package:deniz_gold/data/toast_data.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';

import '../app_config/app_config_cubit.dart';

part 'receipt_screen_state.dart';

@injectable
class ReceiptScreenCubit extends Cubit<ReceiptScreenState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;
  final eventListener = StreamController<ToastData>();

  ReceiptScreenCubit(this.appRepository, this.sharedPreferences) : super(const ReceiptScreenState());

  getData() async {
    emit(state.copyWith(listIsLoading: true));
    final result = await appRepository.getReceipt();
    emit(state.copyWith(listIsLoading: false));
    result.fold(
      (l) => eventListener.add(ToastData(message: l.message!, type: ToastType.error)),
      (r) {
        emit(state.copyWith(receipts: r));
      },
    );
  }

  Future<void> sendFish({
    required String name,
    required String trackingCode,
    required String price,
    required XFile file,
    required String deviceType,
  }) async {
    emit(state.copyWith(buttonIsLoading: true));
    final String fcmToken = sharedPreferences.getString(fcmTokenKey);
    final result = await appRepository.setFish(
      name: name,
      trackingCode: trackingCode,
      price: price.replaceAll(",", ""),
      fcmToken: fcmToken,
      file: file,
    );
    emit(state.copyWith(buttonIsLoading: false));

    result.fold((l) {
      eventListener.add(ToastData(message: l.message!, type: ToastType.error));
    }, (r) {
      eventListener.add(ToastData(message: r));
      getData();
    });
  }
}
