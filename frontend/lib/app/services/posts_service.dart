import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pds_front/app/models/api_response_model.dart';
import 'package:pds_front/app/models/paginated_data_model.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/services/user_service.dart';

class PostService {
  Future<PaginatedDataModel<PostModel>> getAllPosts(int take, int skip) async {
    var loginResponseModel = await UserService.getUserData();

    var url = Uri.parse(
        'http://localhost:3000/v1/posts?search=&take=$take&skip=$skip');
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

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create post');
    }
  }

  Future<void> deletePost(String postId) async {
    var loginResponseModel = await UserService.getUserData();

    var url = Uri.parse('http://localhost:3000/v1/posts/$postId');
    var response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer ${loginResponseModel.accessToken}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar o post');
    }
  }
}
