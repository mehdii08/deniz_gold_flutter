import 'package:equatable/equatable.dart';

class BriefCoinDTO extends Equatable {
  final int id;
  final String name;
  final String price;
  final String discount;
  final String unit;

  const BriefCoinDTO({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.unit,
  });

  factory BriefCoinDTO.fromJson(Map<String, dynamic> json) => BriefCoinDTO(
        id: json['id'] ?? 0,
        name: json['title'],
        price: json['price'],
        discount: json['change'],
        unit: json['unit'],
      );

  BriefCoinDTO updatePrice({required String buyPrice}) => BriefCoinDTO(id: id, name: name, price: buyPrice, discount: discount, unit: unit);

  @override
  List<Object?> get props => [id, discount, price, discount, unit];
}
