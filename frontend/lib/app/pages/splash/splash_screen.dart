import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pds_front/app/pages/dashboard/admin_login_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/posts_page.dart';

/*
Mostra um ícone e carregando por 2 segundos (Future.delayed) → isso simula uma “tela de carregamento”.

Usa o SharedPreferences para verificar se existe um valor salvo com a chave "AccountData".

Se existe:

Vai direto para a HomePage.

Se não existe:

Vai para a AdminLoginScreen (tela de login).
*/
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("AccountData");

    print(
        'Dados salvos no login: $userData'); // <- Aqui mostra se tem algo salvo

    await Future.delayed(const Duration(seconds: 2)); // só para simular loading

    if (userData != null) {
      // Se quiser validar o token aqui, pode
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PostsPage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.admin_panel_settings,
                size: 80, color: Color(0xFF91E4E2)),
            SizedBox(height: 16),
            CircularProgressIndicator(color: Color(0xFF91E4E2)),
          ],
        ),
      ),
    );
  }
}
