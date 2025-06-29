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

  static Future<bool> isLoggedIn() async {
    final storage = await SharedPreferences.getInstance();
    var rawData = storage.getString("AccountData");
    if (rawData == null) {
      return false;
    }

    var loginResponseModel = LoginResponseModel.fromJson(jsonDecode(rawData));

    // TODO: verificar se o token não expirou
    // TODO: caso o token estiver expirado, pegar um novo token e salvar no storage

    if (loginResponseModel.accessToken != null &&
        loginResponseModel.accessToken!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
