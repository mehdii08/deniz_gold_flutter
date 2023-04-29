import 'package:equatable/equatable.dart';

class TradeSubmitResponseDTO extends Equatable {
  final String message;
  final int requestId;

  const TradeSubmitResponseDTO({
    required this.message,
    required this.requestId,
  });

  factory TradeSubmitResponseDTO.fromJson(Map<String, dynamic> json) =>
      TradeSubmitResponseDTO(
        message: json['message'],
        requestId: json['request_id'],
      );

  @override
  List<Object?> get props => [message, requestId];
}
