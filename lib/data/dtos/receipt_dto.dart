import 'package:equatable/equatable.dart';

class ReceiptDTO extends Equatable {
  final String price;
  final String name;
  final String unit;
  final String? trackingCode;
  final String date;

  const ReceiptDTO({
    required this.price,
    required this.name,
    required this.trackingCode,
    required this.date,
    required this.unit,
  });

  factory ReceiptDTO.fromJson(Map<String, dynamic> json) => ReceiptDTO(
        price: json['price'],
        name: json['owner_name'],
        trackingCode: json['tracking_code'],
        date: json['date'],
        unit: json['unit'],
      );

  @override
  List<Object?> get props => [price, name, trackingCode, date];
}
