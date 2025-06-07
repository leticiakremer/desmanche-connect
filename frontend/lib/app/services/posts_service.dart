import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pds_front/app/models/api_response_model.dart';
import 'package:pds_front/app/models/paginated_data_model.dart';
import 'package:pds_front/app/models/post_model.dart';

class PostService {
  static Future<PaginatedDataModel<PostModel>> getAllPosts() async {
    var url = Uri.parse('http://localhost:3000/v1/posts?search=');
    var response = await http.get(url);
    var parsedBody = jsonDecode(response.body);

    var apiResponse = ApiResponseModel<PaginatedDataModel<PostModel>>.fromJson(
      parsedBody,
      (json) => PaginatedDataModel<PostModel>.fromJson(
        json,
        (item) => PostModel.fromJson(item),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to load posts');
    }

    return apiResponse.data!;
  }
}
