import 'package:equatable/equatable.dart';

class TradeDTO extends Equatable {
  final String title;
  final int type;
  final int mazaneh;
  final String faDate;
  final String faTime;
  final int requestId;

  const TradeDTO({
    required this.title,
    required this.type,
    required this.mazaneh,
    required this.faDate,
    required this.faTime,
    required this.requestId,
  });

  factory TradeDTO.fromJson(Map<String, dynamic> json) => TradeDTO(
        title: json['title'],
        type: json['type'],
        mazaneh: json['mazaneh'],
        faDate: json['FaDate'],
        faTime: json['FaTime'],
        requestId: json['id'],
      );

  @override
  List<Object?> get props => [title, type, mazaneh, faDate, faTime, requestId,];
}
