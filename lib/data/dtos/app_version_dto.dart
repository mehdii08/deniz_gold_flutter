import 'package:equatable/equatable.dart';

class AppVersionDTO extends Equatable {
  final int versionCode;
  final int forceVersionCode;
  final String version;
  final bool forceUpdate;
  final String link;
  final bool shooUpdateDetailes;
  final List<String> Description;

  const AppVersionDTO({
    required this.versionCode,
    required this.forceVersionCode,
    required this.version,
    required this.forceUpdate,
    required this.link,
    required this.shooUpdateDetailes,
    required this.Description,
  });

  factory AppVersionDTO.fromJson(Map<String, dynamic> json) => AppVersionDTO(
    versionCode: (json != null && json.keys.contains("version_code")) ?  json['version_code'] : 0,
    forceVersionCode: (json != null && json.keys.contains("force_version_code")) ?  json['force_version_code'] : 0,
    version: (json != null && json.keys.contains("version")) ?  json['version'] : "0",
    forceUpdate: (json != null && json.keys.contains("force_update")) ? json['force_update'] : true,
    link: (json != null && json.keys.contains("version")) ? json['link'] : "https://aghighgold.ir",
    shooUpdateDetailes: (json != null && json.keys.contains("features")) ? json['features']["show"] : false,
    Description: (json != null && json.keys.contains("features")) ?   List<String>.from(json['features']["list"].map((e) => e))
        .toList()
    : [],
  );

  Map<String, dynamic> toJson() => {
    'version': version,
    'force_update': forceUpdate,
    'link': link,
  };
  @override
  List<Object?> get props => [version, forceUpdate, link];
}
