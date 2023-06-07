part of 'havale_cubit.dart';

extension HavaleExtension on PaginatedResultDTO<HavaleDTO> {

  PaginatedResultDTO<HavaleDTO> updateWithNotification({required HavaleDTO havaleDTO}) {
    List<HavaleDTO> newItems = [];
    for (var element in items) {
      if (element.id == havaleDTO.id) {
        newItems.add(havaleDTO);
      } else {
        newItems.add(element);
      }
    }
    return PaginatedResultDTO<HavaleDTO>(
      items: newItems,
      from: from,
      to: to,
      count: count,
      perPage: perPage,
      currentPage: currentPage,
      lastPage: lastPage,
    );
  }
}

abstract class HavaleState extends Equatable {
  final PaginatedResultDTO<HavaleDTO> result;

  const HavaleState({required this.result});

  @override
  List<Object?> get props => [result];
}

class HavaleInitial extends HavaleState {
  const HavaleInitial({required PaginatedResultDTO<HavaleDTO> result}) : super(result: result);
}

class HavaleLoading extends HavaleState {
  final bool isList;

  const HavaleLoading({
    this.isList = false,
    required PaginatedResultDTO<HavaleDTO> result,
  }) : super(result: result);
}

class HavaleLoaded extends HavaleState {
  final String? message;
  const HavaleLoaded({required PaginatedResultDTO<HavaleDTO> result, this.message}) : super(result: result);
}

class HavaleFailed extends HavaleState {
  final String message;

  const HavaleFailed({
    required PaginatedResultDTO<HavaleDTO> result,
    required this.message,
  }) : super(result: result);

  @override
  List<Object?> get props => [result, message];
}
