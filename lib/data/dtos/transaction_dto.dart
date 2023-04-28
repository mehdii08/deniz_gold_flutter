import 'package:equatable/equatable.dart';

class TransactionDTO extends Equatable {
  final String title;
  final String date;
  final String time;

  const TransactionDTO({
    required this.title,
    required this.date,
    required this.time,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) => TransactionDTO(
        title: json['title'],
        date: json['date'],
        time: json['time'],
      );

  @override
  List<Object?> get props => [title, date, time];
}
