import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pds_front/app/models/api_response_model.dart';
import 'package:pds_front/app/models/login_response_model.dart';
import 'package:pds_front/app/models/paginated_data_model.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  Future<PaginatedDataModel<PostModel>> getAllPosts() async {
    final storage = await SharedPreferences.getInstance();
    var loginResponseModel = LoginResponseModel.fromJson(
        jsonDecode(storage.getString("AccountData")!));

    var url = Uri.parse('http://localhost:3000/v1/posts?search=');
    var response = await http.get(url,
        headers: {'Authorization': 'Bearer ${loginResponseModel.accessToken}'});

    var parsedBody = jsonDecode(response.body);
    var apiResponse = ApiResponseModel.fromJson(
        parsedBody,
        (json) => PaginatedDataModel<PostModel>.fromJson(
              json,
              (item) => PostModel.fromJson(item),
            ));
    if (apiResponse.data == null) {
      throw Exception('Failed to load posts');
    }

    return apiResponse.data!;
  }

  Future createPost(PostModel post) async {
    var url = Uri.parse('http://localhost:3000/v1/posts');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create post');
    }
  }
}
