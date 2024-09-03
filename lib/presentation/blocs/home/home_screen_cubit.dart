import 'package:deniz_gold/data/dtos/home_screen_data_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../data/dtos/trade_info_dto.dart';

part 'home_screen_state.dart';

@injectable
class HomeScreenCubit extends Cubit<HomeScreenState> {
  final AppRepository appRepository;
  final Stream<AppNotificationEvent> appNotificationEvents;

  HomeScreenCubit({
    required this.appRepository,
    required this.appNotificationEvents,
  }) : super(const HomeScreenInitial()) {
    appNotificationEvents.listen((event) {
      if (event is HomeDataNotificationEvent) {
        if (state is HomeScreenLoaded) {
          emit((state as HomeScreenLoaded).update(event.data));
        }
      }else if (event is CoinsPriceNotificationEvent) {
        if (state is HomeScreenLoaded) {
          emit((state as HomeScreenLoaded).updateCoin(event.coins));
        }
      }
    });
  }

  getData({bool silent = false}) async {
    if (!silent) {
      emit(const HomeScreenLoading());
    }
    final result = await appRepository.getHomeData();
    result.fold(
      (l) => {
        if (!silent) {emit(HomeScreenFailed(message: l.message != null ? l.message! : ""))}
      },
      (r) => emit(HomeScreenLoaded(data: r)),
    );
  }
}
