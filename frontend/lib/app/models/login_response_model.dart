class LoginResponseModel {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresAt;
  final int? refreshTokenExpiresAt;

  LoginResponseModel({
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.refreshTokenExpiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt,
      'refreshTokenExpiresAt': refreshTokenExpiresAt,
    };
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: json['expiresAt'] as int?,
      refreshTokenExpiresAt: json['refreshTokenExpiresAt'] as int?,
    );
  }
}
