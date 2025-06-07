import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/pages/about_screen.dart';
import 'package:pds_front/app/pages/help_screen.dart';
import 'package:pds_front/app/pages/posts/post_create_screen.dart';
import 'package:pds_front/app/services/posts_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String selectedItem = '';

class _HomePageState extends State<HomePage> {
  List<PostModel> posts = [];

  @override
  void initState() {
    super.initState();
  }

  void getAllPosts() async {
    final allPosts = await PostService.getAllPosts();
    setState(() {
     posts = allPosts;
    });
  }

  Widget buildDrawerItem(String title, IconData icon) {
    final isSelected = selectedItem == title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB2F1F0) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? Colors.black : Colors.white70,
            size: 20,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            setState(() {
              selectedItem = title;
            });

            if (title == "Sobre nós") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            } else if (title == "Ajuda") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF171821),
        border: Border(
          right: BorderSide(
            color: Colors.white24,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB2F1F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.directions_car_filled,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                buildDrawerItem("Sobre nós", Icons.info_outline),
                buildDrawerItem("Postagens", Icons.article),
                buildDrawerItem("Promoções", Icons.local_offer),
                buildDrawerItem("Ajuda", Icons.help_outline),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Jefferson Kremer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "autodemolidora@gmail.com",
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: const Text(
              "Sair",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              debugPrint("Usuário clicou em sair.");
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          buildDrawer(),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF171821),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Desmanche Connect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB2F1F0),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreatePostPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white,),
                        label: const Text("Criar Post"),
                      ),
                    ],
                  ),
                ),
                IconButton.filled(
                  onPressed: getAllPosts,
                  icon: const Icon(Icons.call),
                ),
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
                              Image.memory(
                                imageBytes,
                                fit: BoxFit.fitHeight,
                                height: 200,
                                width: double.infinity,
                              )
                            else
                              const SizedBox(
                                height: 200,
                                child:
                                    Center(child: Text("Imagem indisponível")),
                              ),
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
        ],
      ),
    );
  }
}
