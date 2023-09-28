part of 'receipt_screen_cubit.dart';

class ReceiptScreenState extends Equatable {
  final bool listIsLoading;
  final bool buttonIsLoading;
  final PaginatedResultDTO<ReceiptDTO> result;


  const ReceiptScreenState({
    required this.result ,
    this.listIsLoading = false,
    this.buttonIsLoading = false,
  });

  @override
  List<Object?> get props => [
    result,
        listIsLoading,
        buttonIsLoading,
      ];

  ReceiptScreenState copyWith({
     PaginatedResultDTO<ReceiptDTO>? result,
    bool? listIsLoading,
    bool? buttonIsLoading,
  }) =>
      ReceiptScreenState(
        result: result?? this.result,
        listIsLoading: listIsLoading ?? this.listIsLoading,
        buttonIsLoading: buttonIsLoading ?? this.buttonIsLoading,
      );
}
