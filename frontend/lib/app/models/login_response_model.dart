import 'user_model.dart'; // ajuste o import se necessário

class LoginResponseModel {
  String? accessToken;
  String? refreshToken;
  int? expiresAt;
  int? refreshTokenExpiresAt;
  UserModel? user;

  LoginResponseModel({
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.refreshTokenExpiresAt,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return LoginResponseModel(
      accessToken: data['accessToken'] as String?,
      refreshToken: data['refreshToken'] as String?,
      expiresAt: data['expiresAt'] as int?,
      refreshTokenExpiresAt: data['refreshTokenExpiresAt'] as int?,
      user: data['user'] != null ? UserModel.fromJson(data['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt,
      'refreshTokenExpiresAt': refreshTokenExpiresAt,
      'user': user?.toJson(),
    };
  }
}
