import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/pages/public/public_post_card.dart';
import 'package:pds_front/app/services/posts_service.dart';

class PublicHomePage extends StatefulWidget {
  const PublicHomePage({super.key});

  @override
  State<PublicHomePage> createState() => _PublicHomePageState();
}

class _PublicHomePageState extends State<PublicHomePage> {
  final PostService _postService = PostService();
  List<PostModel> posts = [];
  bool isLoading = true;
  String _searchTerm = '';

  final int _take = 12;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final search = extra?['search'] as String? ?? '';
    if (search != _searchTerm) {
      _searchTerm = search;
    }
    fetchPosts(search: search);
  }

  Future<void> fetchPosts({String? search}) async {
    setState(() => isLoading = true);
    try {
      final paginated =
          await _postService.getPublicPosts(_take, 0, search ?? '');
      setState(() {
        posts = paginated.items.where((post) => post.active).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Erro ao buscar posts: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171821),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Column(
                children: [
                  Text(
                    'Bem-vindo ao Desmanche Connect',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Encontre as melhores peças e componentes disponíveis para desmanche',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (posts.isEmpty)
              const Center(
                  child: Text('Nenhuma postagem encontrada',
                      style: TextStyle(color: Colors.white70)))
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  int crossAxisCount = 1;
                  if (width >= 2400)
                    crossAxisCount = 6;
                  else if (width >= 1920)
                    crossAxisCount = 5;
                  else if (width >= 1440)
                    crossAxisCount = 4;
                  else if (width >= 1024)
                    crossAxisCount = 3;
                  else if (width >= 600) crossAxisCount = 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 16 / 14),
                    itemBuilder: (context, index) =>
                        PublicPostCard(post: posts[index]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
