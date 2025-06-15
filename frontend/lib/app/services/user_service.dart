import 'dart:convert';

import 'package:pds_front/app/models/api_response_model.dart';
import 'package:pds_front/app/models/login_request_model.dart';
import 'package:pds_front/app/models/login_response_model.dart';
import 'package:http/http.dart' as http;

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
}
