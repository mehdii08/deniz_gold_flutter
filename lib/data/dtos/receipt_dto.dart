import 'package:equatable/equatable.dart';

class ReceiptDTO extends Equatable {
  final String imageUrl;
  final String date;
  final String time;
  final int status;
  final String statusString;

  const ReceiptDTO({
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.status,
    required this.statusString,
  });

  factory ReceiptDTO.fromJson(Map<String, dynamic> json) => ReceiptDTO(
        imageUrl: json['image'],
        date: json['date'],
        time: json['time'],
        status: json['approved'],
        statusString: json['approved_string'],
      );

  @override
  List<Object?> get props => [imageUrl, date, time, status, statusString];
}
