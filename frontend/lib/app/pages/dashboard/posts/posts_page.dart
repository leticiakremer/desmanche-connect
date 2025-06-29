import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/widgets/header_widget.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_card.dart';
import 'package:pds_front/app/services/posts_service.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final PostService postService = PostService();
  List<PostModel> posts = [];
  final int defaultTake = 18;
  int currentSkip = 0;

  void getAllPosts() async {
    final postsPaginated =
        await postService.getAllPosts(defaultTake, currentSkip);
    currentSkip += defaultTake;
    setState(() {
      posts = postsPaginated.items;
    });
  }

  void _openWhatsapp() async {
    final Uri url = Uri.parse(
        "https://wa.me/555195173628?text=Oi,%20tudo%20bem?%20Poderia%20me%20ajudar%20com%20uma%20informa%C3%A7%C3%A3o?");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir o WhatsApp");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 280;
    int crossAxisCount =
        (MediaQuery.of(context).size.width / cardWidth).floor().clamp(1, 6);

    return Stack(
      children: [
        Column(
          children: [
            HeaderWidget(
              title: 'Postagens',
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB2F1F0),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  context.go(RouteManager.createPost);
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Criar Post"),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: posts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) => PostCard(post: posts[index]),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
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
                tooltip: "Contato via WhatsApp",
                child: const Icon(
                  Icons.phone,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
