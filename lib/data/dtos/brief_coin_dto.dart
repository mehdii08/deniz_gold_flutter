import 'package:equatable/equatable.dart';

class BriefCoinDTO extends Equatable {
  final String name;
  final String price;
  final String discount;

  const BriefCoinDTO({
    required this.name,
    required this.price,
    required this.discount,
  });

  factory BriefCoinDTO.fromJson(Map<String, dynamic> json) =>
      BriefCoinDTO(
        name: json['title'],
        price: json['price'],
        discount: json['change'],
      );

  @override
  List<Object?> get props => [discount, price, discount];
}