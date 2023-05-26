part of 'havaleh_owner_cubit.dart';

abstract class HavalehOwnerState extends Equatable {

  const HavalehOwnerState();

  @override
  List<Object?> get props => [];
}

class HavalehOwnerInitial extends HavalehOwnerState {
  const HavalehOwnerInitial() : super();
}

class HavalehOwnerLoading extends HavalehOwnerState {
  const HavalehOwnerLoading() : super();

  @override
  List<Object?> get props => [];
}

class HavalehOwnerLoaded extends HavalehOwnerState {
  final Map<String, int> selectableItems;
  const HavalehOwnerLoaded({required this.selectableItems});

  @override
  List<Object?> get props => [selectableItems];
}

class HavalehOwnerFailed extends HavalehOwnerState {
  final String message;

  const HavalehOwnerFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
