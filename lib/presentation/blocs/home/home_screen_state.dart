part of 'home_screen_cubit.dart';

abstract class HomeScreenState extends Equatable {

  const HomeScreenState();

  @override
  List<Object?> get props => [];
}

class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial() : super();
}

class HomeScreenLoading extends HomeScreenState {
  const HomeScreenLoading() : super();

  @override
  List<Object?> get props => [];
}

class HomeScreenLoaded extends HomeScreenState {
  final HomeScreenDataDTO data;
  const HomeScreenLoaded({required this.data});

  @override
  List<Object?> get props => [data];

  HomeScreenState update(HomeScreenDataDTO newData) => HomeScreenLoaded(
    data : data.update(newData)
  );

  HomeScreenState updateCoin(List<CoinTradeInfoDTO> coins) =>
      HomeScreenLoaded(data: data.updateCoin(coins));
}

class HomeScreenFailed extends HomeScreenState {
  final String message;

  const HomeScreenFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
