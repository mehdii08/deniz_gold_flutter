import 'package:equatable/equatable.dart';

class UserDTO extends Equatable {
  final String name;
  final int statusCode;
  final String statusText;
  final String nationalCode;
  final bool accountingStatus;

  const UserDTO({
    required this.name,
    required this.statusCode,
    required this.statusText,
    required this.nationalCode,
    required this.accountingStatus,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        name: json['name'],
        statusCode: json['status_code'],
        statusText: json['status_text'],
        nationalCode: json['national_code'],
        accountingStatus: json['accounting_status'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'status_code': statusCode,
        'status_text': statusText,
        'national_code': nationalCode,
        'accounting_status': accountingStatus,
      };

  UserDTO update({String? newName, String? newNationalCode}) => UserDTO(
        name: (newName != null && newName.isNotEmpty) ? newName : name,
        nationalCode: (newNationalCode != null && newNationalCode.isNotEmpty)
            ? newNationalCode
            : nationalCode,
        statusCode: statusCode,
        statusText: statusText,
        accountingStatus: accountingStatus,
      );

  @override
  List<Object?> get props => [name, statusCode, statusText];
}
