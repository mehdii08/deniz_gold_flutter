import 'package:equatable/equatable.dart';

class HavaleDTO extends Equatable {
  final String title;
  final int status;
  final String statusText;
  final String date;
  final String time;

  const HavaleDTO({
    required this.title,
    required this.status,
    required this.statusText,
    required this.date,
    required this.time,
  });

  factory HavaleDTO.fromJson(Map<String, dynamic> json) => HavaleDTO(
        title: json['title'],
        status: json['status'],
        statusText: json['status_text'],
        date: json['date'],
        time: json['time'],
      );

  @override
  List<Object?> get props => [title, status, statusText, date, time];
}
