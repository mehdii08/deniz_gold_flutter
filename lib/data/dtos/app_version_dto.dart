import 'package:equatable/equatable.dart';

class AppVersionDTO extends Equatable {
  final int versionCode;
  final String version;
  final bool forceUpdate;
  final String link;

  const AppVersionDTO({
    required this.versionCode,
    required this.version,
    required this.forceUpdate,
    required this.link,
  });

  factory AppVersionDTO.fromJson(Map<String, dynamic> json) => AppVersionDTO(
    versionCode: (json != null && json.keys.contains("version_code")) ?  json['version_code'] : 0,
    version: (json != null && json.keys.contains("version")) ?  json['version'] : "0",
    forceUpdate: (json != null && json.keys.contains("version")) ? json['force_update'] : true,
    link: (json != null && json.keys.contains("version")) ? json['link'] : "https://aghighgold.ir",
  );

  Map<String, dynamic> toJson() => {
    'version': version,
    'force_update': forceUpdate,
    'link': link,
  };
  @override
  List<Object?> get props => [version, forceUpdate, link];
}
