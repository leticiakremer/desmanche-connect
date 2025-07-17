import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/services/posts_service.dart';

class PublicPostDetailsPage extends StatelessWidget {
  final String postId;

  const PublicPostDetailsPage({super.key, required this.postId});

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
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: const Color(0xFF171821),
        appBar: AppBar(
  backgroundColor: const Color(0xFF171821),
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    context.go('/'); // volta para tela inicial pública se não puder dar pop
  }
},

  ),
  title: const Text("Detalhes do Post"),
),

        body: FutureBuilder<PostModel>(
          future: PostService().getPublicPostById(postId), // 🔁 IMPORTANTE
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Post não encontrado'));
            }

            final post = snapshot.data!;
            final imageUrl =
                'http://localhost:3000/v1/posts/images/${post.images[post.coverImage]}';

            return Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Card(
                        color: const Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 250,
                                      color: Colors.grey[300],
                                      width: double.infinity,
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 40, color: Colors.red),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.title,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    post.description,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Colors.black54,
                                        ),
                                  ),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 10,
                                    children: [
                                      Chip(
                                        label: Text("Categoria: ${post.category}", style: const TextStyle(color: Colors.black87)),
                                        avatar: const Icon(Icons.category, size: 18, color: Colors.black87),
                                        backgroundColor: Colors.grey[300],
                                      ),
                                      Chip(
                                        label: Text("Preço: R\$ ${post.price?.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black87)),
                                        avatar: const Icon(Icons.attach_money, size: 18, color: Colors.black87),
                                        backgroundColor: Colors.grey[300],
                                      ),
                                      Chip(
                                        label: Text(
                                          post.active ? "Ativo" : "Inativo",
                                          style: TextStyle(
                                            color: post.active ? Colors.green[800] : Colors.red[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: post.active ? Colors.green[100] : Colors.red[100],
                                        avatar: Icon(
                                          post.active ? Icons.check_circle : Icons.cancel,
                                          color: post.active ? Colors.green[700] : Colors.red[700],
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
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
            );
          },
        ),
      ),
    );
  }
}
