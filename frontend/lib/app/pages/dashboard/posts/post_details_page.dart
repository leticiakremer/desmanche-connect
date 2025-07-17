import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/services/posts_service.dart';
import 'package:pds_front/config.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;
  final ScrollController controller = ScrollController();
  PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: const Color(0xFF171821),
        appBar: AppBar(
          title: const Text("Detalhes do Post"),
          backgroundColor: const Color(0xFF171821),
          elevation: 0,
        ),
        body: FutureBuilder<PostModel>(
          future: PostService().getPostById(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Post não encontrado'));
            }

            final post = snapshot.data!;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Card(
                    color: const Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 250,
                          child: ScrollConfiguration(
                              behavior: const ScrollBehavior().copyWith(
                                scrollbars: false,
                                dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: controller,
                                itemCount: post.images.length,
                                itemBuilder: (context, index) {
                                  final imageUrl =
                                      '${AppConfig.baseUrl}posts/images/${post.images[index]}';
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 300,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 300,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(Icons.broken_image,
                                                  size: 40, color: Colors.red),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.black54,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 12,
                                runSpacing: 10,
                                children: [
                                  Chip(
                                    label: Text(
                                      "Categoria: ${post.category}",
                                      style: const TextStyle(
                                          color: Colors.black87),
                                    ),
                                    avatar: const Icon(Icons.category,
                                        size: 18, color: Colors.black87),
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  Chip(
                                    label: Text(
                                      "Preço: R\$ ${post.price?.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.black87),
                                    ),
                                    avatar: const Icon(Icons.attach_money,
                                        size: 18, color: Colors.black87),
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  Chip(
                                    label: Text(
                                      post.active ? "Ativo" : "Inativo",
                                      style: TextStyle(
                                        color: post.active
                                            ? Colors.green[800]
                                            : Colors.red[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: post.active
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    avatar: Icon(
                                      post.active
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: post.active
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
