import 'package:equatable/equatable.dart';

class CoinTradeSubmitResponseDTO extends Equatable {
  final int requestId;
  final int timeForCancel;

  const CoinTradeSubmitResponseDTO({
    required this.requestId,
    required this.timeForCancel,
  });

  factory CoinTradeSubmitResponseDTO.fromJson(Map<String, dynamic> json) {
    return CoinTradeSubmitResponseDTO(
      requestId: json['request_id'],
      timeForCancel: json['time_for_cancel'],
    );
  }

  @override
  List<Object?> get props => [
        requestId,
        timeForCancel,
      ];
}
