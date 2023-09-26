part of 'receipt_screen_cubit.dart';

class ReceiptScreenState extends Equatable {
  final List<ReceiptDTO> receipts;
  final bool listIsLoading;
  final bool buttonIsLoading;

  const ReceiptScreenState({
    this.receipts = const [],
    this.listIsLoading = false,
    this.buttonIsLoading = false,
  });

  @override
  List<Object?> get props => [
        receipts,
        listIsLoading,
        buttonIsLoading,
      ];

  ReceiptScreenState copyWith({
    List<ReceiptDTO>? receipts,
    bool? listIsLoading,
    bool? buttonIsLoading,
  }) =>
      ReceiptScreenState(
        receipts: receipts ?? this.receipts,
        listIsLoading: listIsLoading ?? this.listIsLoading,
        buttonIsLoading: buttonIsLoading ?? this.buttonIsLoading,
      );
}
