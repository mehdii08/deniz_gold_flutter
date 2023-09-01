import 'package:equatable/equatable.dart';

class BriefCoinDTO extends Equatable {
  final int id;
  final String name;
  final String price;
  final String change;
  final String unit;
  final bool isNew;

  const BriefCoinDTO({
    required this.id,
    required this.name,
    required this.price,
    required this.change,
    required this.unit,
    required this.isNew,
  });

  factory BriefCoinDTO.fromJson(Map<String, dynamic> json) => BriefCoinDTO(
        id: json['id'] ?? 0,
        name: json['title'],
        price: json['price'],
        change: json['change'],
        unit: json['unit'],
        isNew: json['is_new'],
      );

  BriefCoinDTO updatePrice({required String buyPrice}) => BriefCoinDTO(
        id: id,
        name: name,
        price: buyPrice,
        change: change,
        unit: unit,
        isNew: isNew,
      );

  @override
  List<Object?> get props => [id, change, price, unit, isNew];
}
