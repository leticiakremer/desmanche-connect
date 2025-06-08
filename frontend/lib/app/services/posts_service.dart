import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pds_front/app/models/api_response_model.dart';
import 'package:pds_front/app/models/paginated_data_model.dart';
import 'package:pds_front/app/models/post_model.dart';

class PostService {
  Future<PaginatedDataModel<PostModel>> getAllPosts() async {
    var url = Uri.parse('http://localhost:3000/v1/posts?search=');
    var response = await http.get(url);
    var parsedBody = jsonDecode(response.body);
    var apiResponse = ApiResponseModel.fromJson(parsedBody);
    if (apiResponse.data == null) {
      throw Exception('Failed to load posts');
    }
    var paginatedData = PaginatedDataModel<PostModel>.fromJson(
      apiResponse.data!,
      (json) => PostModel.fromJson(json),
    );

    return paginatedData;
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
