import 'package:equatable/equatable.dart';

class TradeSubmitResponseDTO extends Equatable {
  final String message;
  final int requestId;
  final int timeForCancel;

  const TradeSubmitResponseDTO({
    required this.message,
    required this.requestId,
    required this.timeForCancel,
  });

  factory TradeSubmitResponseDTO.fromJson(Map<String, dynamic> json) =>
      TradeSubmitResponseDTO(
        message: json['message'],
        requestId: json['request_id'],
        timeForCancel: json['time_for_cancel'],
      );

  @override
  List<Object?> get props => [message, requestId, timeForCancel];
}
