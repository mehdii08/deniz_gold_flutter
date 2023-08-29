
import 'package:equatable/equatable.dart';

class CoinTradesDTO extends Equatable {
  final String title;
  final String count;

  const CoinTradesDTO({
    required this.title,
    required this.count,
  });

  factory CoinTradesDTO.fromJson(Map<String, dynamic> json) =>
      CoinTradesDTO(
        count: json['count'],
        title: json['title'],
      );

  @override
  List<Object?> get props =>
      [
        title,
        count,
      ];
}