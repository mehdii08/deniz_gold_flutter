import 'package:equatable/equatable.dart';

class CheckMobileExistsResponseDTO extends Equatable {
  final bool exists;
  final int? smsOtpCodeExpirationTime;

  const CheckMobileExistsResponseDTO({
    required this.exists,
    this.smsOtpCodeExpirationTime,
  });

  factory CheckMobileExistsResponseDTO.fromJson(Map<String, dynamic> json) =>
      CheckMobileExistsResponseDTO(
          exists: json['exists'],
          smsOtpCodeExpirationTime : json['sms_otp_code_expiration_time'],
      );

  @override
  List<Object?> get props => [exists, smsOtpCodeExpirationTime];
}
