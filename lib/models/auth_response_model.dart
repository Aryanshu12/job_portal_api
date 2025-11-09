class AuthResponseModel {
  final String? token;
  final String? refreshToken;
  final String? message;
  final String? error;

  AuthResponseModel({this.token, this.refreshToken, this.message, this.error});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String? ?? json['refresh_token'] as String?,
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }
}
