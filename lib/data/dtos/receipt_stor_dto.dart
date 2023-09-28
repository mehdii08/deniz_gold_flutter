import 'package:deniz_gold/data/dtos/receipt_dto.dart';
import 'package:equatable/equatable.dart';

class ReceiptStoreDTO extends Equatable {
  final String message;
  final ReceiptDTO receiptDTO;


  const ReceiptStoreDTO({
    required this.message,
    required this.receiptDTO,
  });

  factory ReceiptStoreDTO.fromJson(Map<String, dynamic> json) => ReceiptStoreDTO(
    message: json['message'],
    receiptDTO: ReceiptDTO.fromJson(json['data']["receipt"]),
      );

  @override
  List<Object?> get props => [message, receiptDTO];
}
