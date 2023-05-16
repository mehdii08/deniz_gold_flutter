import 'package:deniz_gold/data/dtos/havale_dto.dart';
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

  HavaleCubit(this.appRepository) : super(const HavaleInitial(result: PaginatedResultDTO()));

  storeHavale({
    required String value,
    required String name,
  }) async {
    emit(HavaleLoading(result: state.result));
    final result = await appRepository.storeHavale(
        value: value,
        name: name,
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
