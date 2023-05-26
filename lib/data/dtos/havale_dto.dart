import 'package:deniz_gold/data/dtos/havaleh_owner_dto.dart';
import 'package:equatable/equatable.dart';

class HavaleDTO extends Equatable {
  final String title;
  final String name;
  final int status;
  final String statusText;
  final HavalehOwnerDTO? destination;
  final String date;
  final String time;

  const HavaleDTO({
    required this.title,
    required this.name,
    required this.status,
    required this.statusText,
    required this.destination,
    required this.date,
    required this.time,
  });

  factory HavaleDTO.fromJson(Map<String, dynamic> json) => HavaleDTO(
        title: json['title'],
        name: json['name'],
        status: json['status'],
        statusText: json['status_text'],
        destination: json['destination'] != null ? HavalehOwnerDTO.fromJson(json['destination']) : null,
        date: json['date'],
        time: json['time'],
      );

  @override
  List<Object?> get props => [title, name, status, destination, statusText, date, time];
}
