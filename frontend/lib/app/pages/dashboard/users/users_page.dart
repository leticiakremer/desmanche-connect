import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';
import 'package:pds_front/app/pages/dashboard/users/users_create_page.dart';
import 'package:pds_front/app/widgets/debounce_input.dart';
import 'package:pds_front/app/widgets/header_widget.dart';
import 'package:pds_front/app/services/user_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];

  int skip = 0;
  final int take = 20;
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMore = true;

  String _orderBy = 'name';
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isFetchingMore &&
        hasMore) {
      fetchUsers(loadMore: true);
    }
  }

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (isLoading || isFetchingMore) return;
    if (loadMore) {
      setState(() => isFetchingMore = true);
    } else {
      setState(() => isLoading = true);
    }

    try {
      final newUsers = await UserService.getAllUsers(skip: skip, take: take);
      if (newUsers.isEmpty) {
        hasMore = false;
      } else {
        skip += take;
        users.addAll(newUsers);
        filteredUsers = users.toList();
        _sortUsers();
      }
    } catch (e) {
      debugPrint("Erro ao carregar usuários: $e");
    } finally {
      setState(() {
        isLoading = false;
        isFetchingMore = false;
      });
    }
  }

  void filter(String value) {
    final result = users.where((user) {
      final name = user['name']?.toLowerCase() ?? '';
      final username = user['username']?.toLowerCase() ?? '';
      return name.contains(value.toLowerCase()) ||
          username.contains(value.toLowerCase());
    }).toList();

    setState(() {
      filteredUsers = result;
      _sortUsers();
    });
  }

  void _sortUsers() {
    filteredUsers.sort((a, b) {
      final aValue = (a[_orderBy] ?? '').toLowerCase();
      final bValue = (b[_orderBy] ?? '').toLowerCase();
      return _ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF171821),
      child: Column(
        children: [
          HeaderWidget(
            title: 'Usuários Administradores',
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              onPressed: () {
                context.push(RouteManager.usersCreate);
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Criar usuário"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DebounceInput(
              debounceDuration: const Duration(milliseconds: 500),
              onChanged: filter,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                hintText: "Pesquisar usuário",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF22232B), 
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF007BFF), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: '',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  setState(() => _ascending = !_ascending);
                  _sortUsers();
                },
                icon: Icon(
                  _ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: const Color(0xFF007BFF), 
                ),
                tooltip: 'Ordenar ${_ascending ? "A-Z" : "Z-A"}',
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : filteredUsers.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhum usuário encontrado",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            filteredUsers.length + (isFetchingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == filteredUsers.length && isFetchingMore) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          final user = filteredUsers[index];
                          return _buildUserTile(user);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F28),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.white60, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] ?? 'Sem nome',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['username'] ?? 'Sem username',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _confirmDelete(user),
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            tooltip: 'Excluir usuário',
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> user) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1F28),
        title: const Text("Confirmar exclusão",
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Deseja realmente excluir o usuário "${user['name']}"?',
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
        await UserService.deleteUser(user['id']);
        setState(() {
          users.removeWhere((u) => u['id'] == user['id']);
          filteredUsers.removeWhere((u) => u['id'] == user['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário excluído com sucesso')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir usuário: $e')),
        );
      }
    }
  }
}
