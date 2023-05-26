import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'havaleh_owner_state.dart';

@injectable
class HavalehOwnerCubit extends Cubit<HavalehOwnerState> {
  final AppRepository appRepository;

  HavalehOwnerCubit({
    required this.appRepository,
  }) : super(const HavalehOwnerInitial()){
    getData();
  }

  getData() async {
    emit(const HavalehOwnerLoading());
    final result = await appRepository.getHavalehOwnerList();
    result.fold(
      (l) => emit(HavalehOwnerFailed(message: l.message != null ? l.message! : "")),
      (r) {
        Map<String,int> selectableItems = {for (var item in r) item.title : item.id};
        emit(HavalehOwnerLoaded(selectableItems: selectableItems));
      },
    );
  }

  reset() async {
    emit(const HavalehOwnerInitial());
  }
}
