import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_checker_state.dart';

@injectable
class PermissionCheckerCubit extends Cubit<PermissionCheckerState> {
  final AppRepository appRepository;

  PermissionCheckerCubit({
    required this.appRepository,
  }) : super(const PermissionCheckerLoading()) {
    check();
  }

  check() async {
    emit(const PermissionCheckerLoading());
    final status = await Permission.notification.status;
    emit(PermissionCheckerLoaded(status: status));
  }

  request() async {
    await Permission.notification.request();
    check();
  }
}
