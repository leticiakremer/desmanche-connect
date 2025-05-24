import 'dart:convert';

import 'package:http/http.dart' as http;

class Post {
  final String title;
  final String description;
  final String category;
  final bool active;
  final List<String> images;
  final int coverImage;
  final double price;

  Post(
      {required this.title,
      required this.description,
      required this.category,
      required this.active,
      required this.images,
      required this.coverImage,
      required this.price});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      active: json['active'],
      images: List<String>.from(json['images']),
      coverImage: json['coverImage'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'active': active,
      'images': images,
      'coverImage': coverImage,
      'price': price,
    };
  }

  void imprimeNaTela() {
    print('Título: ${title}');
    print('Imagem de capa: ${images[coverImage]}');
  }
}

void main() async {
  var url = Uri.parse('http://localhost:3000/v1/posts?search=');
  var response = await http.get(url, headers: {
    'Authorization' : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
  });
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
  var parsedBody = jsonDecode(response.body);

  // -- tratar os dados recebidos
  print('response headers: ${response.headers}');
  var posts = (parsedBody as List).map((json) => Post.fromJson(json)).toList();
  print('Posts:');
  for (var post in posts) {
    post.imprimeNaTela();
    print('-------------------');
  }
}

// http.get é uma função da biblioteca http do Dart que realiza uma requisição GET para um servidor.
// 1- Cria o objeto de request internamente
// 2- Realiza a requisição para o servidor internamente 
// 3- Retorna o response da requisição