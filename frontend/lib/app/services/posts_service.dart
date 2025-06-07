import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pds_front/app/models/post_model.dart';

class PostService {
  static Future<List<PostModel>> getAllPosts() async {
    var url = Uri.parse('http://localhost:3000/v1/posts?search=');
    var response = await http.get(url);
    var parsedBody = jsonDecode(response.body);
    return (parsedBody as List)
        .map((json) => PostModel.fromJson(json))
        .toList();
  }

 //  static Future<List<PostModel>> createPost() async {
    
 // }
}
