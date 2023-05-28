import 'package:deniz_gold/data/dtos/phone_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'support_state.dart';

@injectable
class SupportCubit extends Cubit<SupportState> {
  final AppRepository appRepository;
  List<PhoneDTO> _phones = [];

  SupportCubit({
    required this.appRepository,
  }) : super(const SupportInitial());

  getData() async {
    if(_phones.isNotEmpty){
      emit(SupportLoaded(phones: _phones));
      return;
    }
    emit(const SupportLoading());
    final result = await appRepository.getPhones();
    result.fold(
      (l) => emit(SupportFailed(message: l.message != null ? l.message! : "")),
      (r) {
        if(r.isNotEmpty){
          _phones = r;
        }
        emit(SupportLoaded(phones: r));
      },
    );
  }

}
