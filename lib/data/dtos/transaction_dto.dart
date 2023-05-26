import 'package:equatable/equatable.dart';

class TransactionDTO extends Equatable {
  final String type;
  final String title;
  final String description;
  final String date;
  final String time;

  const TransactionDTO({
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) => TransactionDTO(
        type: json['type'],
        title: json['title'],
        description: json['description'],
        date: json['date'],
        time: json['time'],
      );

  @override
  List<Object?> get props => [type, title, description, date, time];
}
