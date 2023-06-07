import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/data/dtos/paginated_result_dto.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:injectable/injectable.dart';

part 'havale_state.dart';

const perPage = 15;

@injectable
class HavaleCubit extends Cubit<HavaleState> {
  final AppRepository appRepository;
  final Stream<AppNotificationEvent> appNotificationEvents;
  final SharedPreferencesRepository sharedPreferences;

  HavaleCubit({
    required this.appRepository,
    required this.appNotificationEvents,
    required this.sharedPreferences,
  })
      : super(const HavaleInitial(result: PaginatedResultDTO())){
    appNotificationEvents.listen((event) {
      if(event is HavalehStatusNotificationEvent){
        if(state is HavaleLoaded){
          emit(HavaleLoaded(result: state.result.updateWithNotification(havaleDTO: event.havaleh)));
        }
      }
    });
  }

  storeHavale({
    required String value,
    required String name,
    required int? destination,
  }) async {
    emit(HavaleLoading(result: state.result));
    final String fcmToken = sharedPreferences.getString(fcmTokenKey);
    final result = await appRepository.storeHavale(
        value: value,
        name: name,
        destination: destination,
        fcmToken: fcmToken
    );
    result.fold(
            (l) => emit(HavaleFailed(result: state.result,message: l.message != null ? l.message! : "")),
            (r) {
          emit(HavaleLoaded(result: state.result.add(item: r), message: Strings.havlehCreated));
        }
    );
  }

  getData() async {
    final result = state.result;
    if (state is! HavaleInitial && result.currentPage == result.lastPage) {
      return;
    }
    emit(HavaleLoading(isList: true, result: state.result));
    final data = await appRepository.getHavales(page: state.result.currentPage + 1);
    data.fold(
      (l) => emit(HavaleFailed(result: state.result, message: l.message != null ? l.message! : "")),
      (r) => emit(HavaleLoaded(result: state.result.update(result: r))),
    );
  }
}
