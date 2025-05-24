import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pds_front/app/data/models/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> posts = [];
  @override
  void initState() {
    super.initState();
  }

  void getAllPosts() async {
    var url = Uri.parse('http://localhost:3000/v1/posts?search=');
    var response = await http.get(url);
    var parsedBody = jsonDecode(response.body);
    setState(() {
      posts =
          (parsedBody as List).map((json) => PostModel.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Consumindo api node',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            IconButton.filled(onPressed: getAllPosts, icon: Icon(Icons.call)),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  Uint8List? imageBytes;

                  if (post.images.isNotEmpty) {
                    try {
                      imageBytes = base64Decode(post.images[0]);
                    } catch (e) {
                      debugPrint("Erro ao decodificar imagem: $e");
                    }
                  }

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        if (imageBytes != null)
                          Image.memory(imageBytes,
                              fit: BoxFit.fitHeight,
                              height: 200,
                              width: double.infinity)
                        else
                          const SizedBox(
                              height: 200,
                              child:
                                  Center(child: Text("Imagem indisponível"))),
                        ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.description),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
