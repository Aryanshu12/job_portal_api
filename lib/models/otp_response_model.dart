class OtpResponseModel {
  final String? message;
  final String? error;
  final bool success;

  OtpResponseModel({this.message, this.error, required this.success});

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      message: json['message'] as String?,
      error: json['error'] as String?,
      success: json['success'] as bool? ?? (json['message'] != null),
    );
  }
}
