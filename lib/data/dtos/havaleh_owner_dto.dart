import 'package:equatable/equatable.dart';

class HavalehOwnerDTO extends Equatable {
  final String title;
  final int id;

  const HavalehOwnerDTO({
    required this.title,
    required this.id,
  });

  factory HavalehOwnerDTO.fromJson(Map<String, dynamic> json) => HavalehOwnerDTO(
        title: json['title'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'gold_balance': id,
      };

  @override
  List<Object?> get props => [
        title,
        id,
      ];
}
