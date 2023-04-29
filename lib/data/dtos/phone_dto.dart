import 'package:equatable/equatable.dart';

class PhoneDTO extends Equatable {
  final String title;
  final String phone;

  const PhoneDTO({
    required this.title,
    required this.phone,
  });

  factory PhoneDTO.fromJson(Map<String, dynamic> json) => PhoneDTO(
        title: json['title'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'phone': phone,
      };

  @override
  List<Object?> get props => [
        title,
        phone,
      ];
}
