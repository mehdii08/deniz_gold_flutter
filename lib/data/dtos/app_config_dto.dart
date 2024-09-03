import 'package:equatable/equatable.dart';
import 'package:deniz_gold/data/dtos/app_version_dto.dart';
import 'package:deniz_gold/data/dtos/phone_dto.dart';
import 'package:deniz_gold/data/dtos/user_dto.dart';

class AppConfigDTO extends Equatable {
  final UserDTO user;
  final String logo;
  final String title;
  final List<PhoneDTO>? phones;
  final String aboutText;
  final String address;
  final AppVersionDTO appVersion;

  const AppConfigDTO({
    required this.user,
    required this.logo,
    required this.title,
    required this.phones,
    required this.aboutText,
    required this.address,
    required this.appVersion,
  });

  factory AppConfigDTO.fromJson(Map<String, dynamic> json) {
    List<PhoneDTO>? phones;
    if (json.keys.contains("phones") &&
        json['phones'] != null &&
        json['phones'] != "null") {
      phones =
          List<PhoneDTO>.from(json['phones'].map((e) => PhoneDTO.fromJson(e)))
              .toList();
    }
    return AppConfigDTO(
        user: UserDTO.fromJson(json['user']),
        logo: json['logo'],
        title: json['title'] ?? '',
        phones: phones,
        aboutText: json['about_text'] ?? "",
        address: json['address'] ?? '',
        appVersion: AppVersionDTO.fromJson(
          json['app_version'],
        ));
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'logo': logo,
        'title': title,
        'phones': phones != null ? phones!.map((e) => e.toJson()).toList() : [],
        'about_text': aboutText,
        'address': address,
        'app_version': appVersion.toJson(),
      };

  @override
  List<Object?> get props => [
        user,
        logo,
        title,
        phones,
        aboutText,
        address,
        appVersion
      ];

  AppConfigDTO update({
    String? newName,
    String? newNationalCode,
    String? newLogo,
    String? newBotStatus,
    String? newCoinStatus,
  }) =>
      AppConfigDTO(
        user: user.update(newName: newName, newNationalCode: newNationalCode),
        logo: newLogo ?? logo,
        title: title,
        phones: phones,
        aboutText: aboutText,
        address: address,
        appVersion: appVersion,
      );
}
