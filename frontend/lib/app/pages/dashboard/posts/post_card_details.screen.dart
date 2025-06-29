import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pds_front/app/models/post_model.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailsScreen({super.key, required this.post});

  void _openWhatsapp() async {
    final Uri url = Uri.parse("https://wa.me/SEUNUMEROAQUI");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir o WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;

    if (post.images.isNotEmpty) {
      try {
        imageBytes = base64Decode(post.images[post.coverImage]);
      } catch (e) {
        debugPrint("Erro ao decodificar imagem: $e");
      }
    }

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: const Color(0xFF171821),
        appBar: AppBar(
          title: Text(post.title),
          backgroundColor: const Color(0xFF171821),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Center(
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
                      children: [
                        imageBytes != null
                            ? Image.memory(
                                imageBytes,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 250,
                                color: Colors.grey[300],
                                width: double.infinity,
                                child: const Center(
                                    child: Text("Imagem indisponível")),
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
                                      "Preço: R\$ ${post.price.toStringAsFixed(2)}",
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
            ),

            // Texto + FAB no canto inferior direito
            Positioned(
              bottom: 20,
              right: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Dúvidas? Fale conosco!",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: _openWhatsapp,
                    backgroundColor: Colors.green,
                    mini: true,
                    child: const Icon(Icons.phone, size: 28),
                    tooltip: "Contato via WhatsApp",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
