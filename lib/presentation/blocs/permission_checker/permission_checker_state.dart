part of 'permission_checker_cubit.dart';

abstract class PermissionCheckerState extends Equatable {

  const PermissionCheckerState();

  @override
  List<Object?> get props => [];
}

class PermissionCheckerLoading extends PermissionCheckerState {
  const PermissionCheckerLoading() : super();

  @override
  List<Object?> get props => [];
}

class PermissionCheckerLoaded extends PermissionCheckerState {
  final PermissionStatus status;
  const PermissionCheckerLoaded({required this.status});

  @override
  List<Object?> get props => [status];
}
