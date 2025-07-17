import 'dart:convert';

import 'package:pds_front/app/models/api_response_model.dart';
import 'package:pds_front/app/models/login_request_model.dart';
import 'package:pds_front/app/models/login_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<ApiResponseModel<LoginResponseModel>> login(
      LoginRequestModel model) async {
    var url = Uri.parse('http://localhost:3000/v1/users/login');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(model.toJson()),
    );
    var parsedJson = jsonDecode(response.body);
    return ApiResponseModel<LoginResponseModel>.fromJson(
      parsedJson,
      (json) => LoginResponseModel.fromJson(json),
    );
  }

  static Future<void> logout() async {
    final storage = await SharedPreferences.getInstance();
    await storage.remove("AccountData");
    await storage.remove("userName");
  }

  static Future<LoginResponseModel> getUserData() async {
    final storage = await SharedPreferences.getInstance();
    var accountData = storage.getString("AccountData");
    if (accountData == null) {
      throw Exception("No user data found");
    }
    return LoginResponseModel.fromJson(jsonDecode(accountData));
  }

  static Future<LoginResponseModel> refreshToken() async {
    final storage = await SharedPreferences.getInstance();
    var rawData = storage.getString("AccountData");
    if (rawData == null) {
      throw Exception("No user data found");
    }

    var loginResponseModel = LoginResponseModel.fromJson(jsonDecode(rawData));

    var url = Uri.parse('http://localhost:3000/v1/users/refresh');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refreshToken': loginResponseModel.refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      var parsedJson = jsonDecode(response.body);
      loginResponseModel.accessToken = parsedJson['accessToken'];
      loginResponseModel.expiresAt = parsedJson['expiresAt'];
      await storage.setString("AccountData", jsonEncode(loginResponseModel));
      return loginResponseModel;
    } else {
      throw Exception("Failed to refresh token");
    }
  }

  static Future<void> deleteUser(String userId) async {
    final user = await getUserData();

    final response = await http.delete(
      Uri.parse('http://localhost:3000/v1/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.accessToken}',
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Erro ao deletar usuário');
    }
  }

  static Future<bool> isLoggedIn() async {
    final storage = await SharedPreferences.getInstance();
    var rawData = storage.getString("AccountData");
    if (rawData == null) {
      return false;
    }

    var loginResponseModel = LoginResponseModel.fromJson(jsonDecode(rawData));
    if (loginResponseModel.accessToken != null &&
        loginResponseModel.expiresAt != null &&
        loginResponseModel.refreshTokenExpiresAt != null &&
        loginResponseModel.accessToken!.isNotEmpty) {
      var currentDateTime = DateTime.now().toUtc();
      var accessTokenExpirationDateTime = DateTime.fromMillisecondsSinceEpoch(
          loginResponseModel.expiresAt!,
          isUtc: true);
      var refreshTokenExpirationDateTime = DateTime.fromMillisecondsSinceEpoch(
          loginResponseModel.refreshTokenExpiresAt!,
          isUtc: true);

      if (refreshTokenExpirationDateTime.isBefore(currentDateTime)) {
        // If the refresh token is expired, user needs to login again
        return false;
      }

      if (accessTokenExpirationDateTime.isBefore(currentDateTime)) {
        try {
          // If the access token is expired, try to refresh it
          await refreshToken();
          return true;
        } catch (e) {
          // If refreshing fails, return false
          return false;
        }
      }

      return true;
    } else {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers(
      {int skip = 0, int take = 20}) async {
    final storage = await SharedPreferences.getInstance();
    final rawData = storage.getString("AccountData");

    if (rawData == null) throw Exception("Usuário não autenticado");

    final loginResponse = LoginResponseModel.fromJson(jsonDecode(rawData));
    final accessToken = loginResponse.accessToken;

    final response = await http.get(
      Uri.parse('http://localhost:3000/v1/users?skip=$skip&take=$take'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> users = json['data']['items'];
      return users.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 401) {
      throw Exception("Sessão expirada. Faça login novamente.");
    } else {
      throw Exception("Erro ao buscar usuários (${response.statusCode})");
    }
  }

  static Future<void> createUser({
    required String name,
    required String username,
    required String password,
  }) async {
    final storage = await SharedPreferences.getInstance();
    final rawData = storage.getString("AccountData");

    if (rawData == null) throw Exception("Usuário não autenticado");

    final loginResponse = LoginResponseModel.fromJson(jsonDecode(rawData));
    final accessToken = loginResponse.accessToken;

    final response = await http.post(
      Uri.parse('http://localhost:3000/v1/users/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Erro ao criar usuário');
    }
  }
}
