import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/widgets/debounce_input.dart';
import 'package:pds_front/app/widgets/header_widget.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_card.dart';
import 'package:pds_front/app/services/posts_service.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  bool? _showOnlyActive;

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

      final result =
          await postService.getAllPosts(defaultTake, currentSkip, _searchTerm);
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
    const double cardWidth = 550;
    int crossAxisCount =
        (MediaQuery.of(context).size.width / cardWidth).floor();

    final filteredPosts = _showOnlyActive == null
        ? posts
        : posts.where((p) => p.active == _showOnlyActive).toList();

    return Column(
      children: [
        HeaderWidget(
          title: 'Postagens',
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF),
              foregroundColor: Colors.white,
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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              hintText: "Buscar postagem",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF22232B), // Fundo escuro
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(12), // 🔹 Borda arredondada
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xFF007BFF), width: 1.5), // 🔹 Azul ao focar
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton2<bool?>(
                  isDense: true,
                  value: _showOnlyActive,
                  hint: const Text(
                    'Filtrar',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Todos'),
                    ),
                    DropdownMenuItem(
                      value: true,
                      child: Text('Ativos'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('Inativos'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _showOnlyActive = value);
                  },
                  buttonStyleData: ButtonStyleData(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    height: 36,
                    width: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F2A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color(0xFF007BFF)),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    offset: const Offset(-30, 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A3C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: 150,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 18,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredPosts.isEmpty && !isLoading
              ? const Center(
                  child: Text(
                    'Nenhuma postagem encontrada',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredPosts.length + (isLoading ? 1 : 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 16 / 10, // 🔹 Proporção do card
                  ),
                  itemBuilder: (context, index) {
                    if (index < filteredPosts.length) {
                      return PostCard(
                          post: filteredPosts[index],
                          onEdit: (id) {
                            context.go(RouteManager.editPostPath(id),
                                extra: filteredPosts[index]);
                          },
                          onDelete: (id) {
                            _confirmDeletePost(filteredPosts[index], index);
                          },
                          onDetails: (id) {
                            context.go(RouteManager.postDetailsPath(id));
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
        ),
      ],
    );
  }

  void _confirmDeletePost(PostModel post, int index) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1F28),
        title: const Text("Confirmar exclusão",
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Deseja realmente excluir o post "${post.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir",
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await postService.deletePost(post.id!);
        setState(() {
          posts.removeWhere((p) => p.id == post.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post excluído com sucesso')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir post: $e')),
        );
      }
    }
  }
}
