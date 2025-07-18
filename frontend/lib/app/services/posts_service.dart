import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pds_front/app/models/api_response_model.dart';
import 'package:pds_front/app/models/create_post_model.dart';
import 'package:pds_front/app/models/paginated_data_model.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/services/user_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pds_front/config.dart';

class PostService {
  Future<PaginatedDataModel<PostModel>> getAllPosts(
      int take, int skip, String? search) async {
    var loginResponseModel = await UserService.getUserData();

    var url = Uri.parse(
        '${AppConfig.baseUrl}posts?search=$search&take=$take&skip=$skip');
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

  Future createPost(CreatePostModel post) async {
    var loginResponseModel = await UserService.getUserData();

    var uri = Uri.parse('${AppConfig.baseUrl}posts');
    var request = http.MultipartRequest('POST', uri);

    // Adiciona o token no header
    request.headers['Authorization'] =
        'Bearer ${loginResponseModel.accessToken}';

    // Serializa os dados do post para JSON e adiciona no campo 'data'
    final postData = {
      'title': post.title,
      'description': post.description,
      'category': post.category,
      'active': post.active,
      'coverImage': post.coverImage,
      'price': post.price,
    };
    request.fields['data'] = jsonEncode(postData);

    // Adiciona as imagens (bytes lidos direto do XFile)
    for (int i = 0; i < post.images.length; i++) {
      final file = post.images[i];
      final bytes = await file.readAsBytes();

      // Extrai mime type da imagem (exemplo: image/jpeg)
      final mimeTypeString = file.mimeType ?? 'image/jpeg';
      final mimeTypeSplit = mimeTypeString.split('/');

      request.files.add(
        http.MultipartFile.fromBytes(
          'images',
          bytes,
          filename: file.name,
          contentType: MediaType(
            mimeTypeSplit[0],
            mimeTypeSplit.length > 1 ? mimeTypeSplit[1] : 'jpeg',
          ),
        ),
      );
    }

    // Envia a requisição
    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create post');
    }
  }

  Future<void> updatePost(String postId, CreatePostModel post) async {
    var loginResponseModel = await UserService.getUserData();

    var uri = Uri.parse('${AppConfig.baseUrl}posts/$postId');
    var request = http.MultipartRequest('PUT', uri);

    // Token de autenticação
    request.headers['Authorization'] =
        'Bearer ${loginResponseModel.accessToken}';

    // Dados principais da postagem
    final postData = {
      'title': post.title,
      'description': post.description,
      'category': post.category,
      'active': post.active,
      'coverImage': post.coverImage,
      'price': post.price,
      'existingImageIds': post.existingImages ?? [],
    };
    request.fields['data'] = jsonEncode(postData);

    // Adiciona imagens (caso tenha imagens novas para enviar)
    for (int i = 0; i < post.images.length; i++) {
      final file = post.images[i];
      final bytes = await file.readAsBytes();

      final mimeTypeString = file.mimeType ?? 'image/jpeg';
      final mimeTypeSplit = mimeTypeString.split('/');

      request.files.add(
        http.MultipartFile.fromBytes(
          'images',
          bytes,
          filename: file.name,
          contentType: MediaType(
            mimeTypeSplit[0],
            mimeTypeSplit.length > 1 ? mimeTypeSplit[1] : 'jpeg',
          ),
        ),
      );
    }

    // Envia requisição
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar post');
    }
  }

  Future<void> deletePost(String postId) async {
    var loginResponseModel = await UserService.getUserData();

    var url = Uri.parse('${AppConfig.baseUrl}posts/$postId');
    var response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer ${loginResponseModel.accessToken}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar o post');
    }
  }

  Future<PostModel> getPostById(String postId) async {
    final loginResponseModel = await UserService.getUserData();

    final url = Uri.parse('${AppConfig.baseUrl}posts/$postId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${loginResponseModel.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar post: ${response.statusCode}');
    }

    final parsedBody = jsonDecode(response.body);

    final apiResponse = ApiResponseModel.fromJson(
      parsedBody,
      (json) => PostModel.fromJson(json),
    );

    if (apiResponse.data == null) {
      throw Exception('Post não encontrado');
    }

    return apiResponse.data!;
  }
// Método para buscar posts públicos, ele é basicamente uma cópia do getAllPosts(), mas sem o token no header.

  Future<PaginatedDataModel<PostModel>> getPublicPosts(
      int take, int skip, String? search) async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}posts?search=$search&take=$take&skip=$skip');

    final response = await http.get(url);

    final parsedBody = jsonDecode(response.body);
    final apiResponse = ApiResponseModel.fromJson(
      parsedBody,
      (json) => PaginatedDataModel<PostModel>.fromJson(
        json,
        (item) => PostModel.fromJson(item),
      ),
    );

    if (apiResponse.data == null) {
      throw Exception('Falha ao carregar posts públicos');
    }

    return apiResponse.data!;
  }

  Future<PostModel> getPublicPostById(String postId) async {
    final url = Uri.parse('${AppConfig.baseUrl}posts/$postId');

    final response = await http.get(url); // Sem token

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar post público');
    }

    final parsedBody = jsonDecode(response.body);

    final apiResponse = ApiResponseModel.fromJson(
      parsedBody,
      (json) => PostModel.fromJson(json),
    );

    if (apiResponse.data == null) {
      throw Exception('Post não encontrado');
    }

    return apiResponse.data!;
  }
}
