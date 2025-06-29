import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/widgets/debounce_input.dart';
import 'package:pds_front/app/widgets/header_widget.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_card.dart';
import 'package:pds_front/app/services/posts_service.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final PostService postService = PostService();
  final ScrollController _scrollController = ScrollController();

  List<PostModel> posts = [];
  final int defaultTake = 18;
  int currentSkip = 0;
  bool isLoading = false;
  bool hasMore = true;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !isLoading &&
        hasMore) {
      _fetchPosts();
    }
  }

  Future<void> _fetchPosts({bool reset = false}) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      if (reset) {
        currentSkip = 0;
        posts.clear();
        hasMore = true;
      }

      final result = await postService.getAllPosts(defaultTake, currentSkip, _searchTerm);
      setState(() {
        posts.addAll(result.items);
        currentSkip += defaultTake;
        hasMore = result.items.length == defaultTake;
      });
    } catch (e) {
      print("Erro ao buscar posts: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 280;
    int crossAxisCount =
        (MediaQuery.of(context).size.width / cardWidth).floor().clamp(1, 6);

    return Column(
      children: [
        HeaderWidget(
          title: 'Postagens',
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB2F1F0),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DebounceInput(
            label: "Buscar postagem",
            debounceDuration: const Duration(milliseconds: 500),
            onChanged: (value) {
              setState(() => _searchTerm = value);
              _fetchPosts(reset: true);
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: posts.length + (isLoading ? 1 : 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              if (index < posts.length) {
                return PostCard(post: posts[index]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
