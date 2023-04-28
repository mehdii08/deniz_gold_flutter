import 'package:equatable/equatable.dart';

class AppVersionDTO extends Equatable {
  final String version;
  final bool forceUpdate;
  final String link;

  const AppVersionDTO({
    required this.version,
    required this.forceUpdate,
    required this.link,
  });

  factory AppVersionDTO.fromJson(Map<String, dynamic> json) => AppVersionDTO(
        version: json['version'],
        forceUpdate: json['force_update'],
        link: json['link'],
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'force_update': forceUpdate,
        'link': link,
      };
  @override
  List<Object?> get props => [version, forceUpdate, link];
}
