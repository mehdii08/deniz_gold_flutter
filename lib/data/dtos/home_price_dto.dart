import 'package:equatable/equatable.dart';

class HomePriceDTO extends Equatable {
  final String price;
  final String unit;

  const HomePriceDTO({
    required this.price,
    required this.unit,
  });

  factory HomePriceDTO.fromJson(Map<String, dynamic> json) => HomePriceDTO(
      price: json['price'],
      unit: json['unit'],
    );

  @override
  List<Object?> get props => [
    price,
    unit,
  ];
}