import 'dart:async';
import 'package:deniz_gold/data/dtos/paginated_result_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
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

  ReceiptScreenCubit(this.appRepository, this.sharedPreferences) : super(const ReceiptScreenState(result: PaginatedResultDTO()));

  getData() async {
    if ( state.result.currentPage!=0&&state.result.currentPage == state.result.lastPage) {
      return;
    }
    emit(state.copyWith(listIsLoading: true,result: state.result));
    final result = await appRepository.getReceipt(page: state.result.currentPage + 1);
    emit(state.copyWith(listIsLoading: false,result: state.result));
    result.fold(
      (l) => eventListener.add(ToastData(message: l.message!, type: ToastType.error)),
      (r) {
        emit(state.copyWith(result: state.result.update(result: r)));
      },
    );
  }

  Future<void> sendFish({
    required XFile file,
  }) async {
    emit(state.copyWith(buttonIsLoading: true,result: state.result));
    final String fcmToken = sharedPreferences.getString(fcmTokenKey);
    final result = await appRepository.setFish(
      fcmToken: fcmToken,
      file: file,
    );
    emit(state.copyWith(buttonIsLoading: false,result: state.result));
    result.fold((l) {
      eventListener.add(ToastData(message: l.message!, type: ToastType.error));
    }, (r) {
      eventListener.add(ToastData(message: r.message));
      emit(state.copyWith(result: state.result.add(item: r.receiptDTO)));

    });
  }
}
