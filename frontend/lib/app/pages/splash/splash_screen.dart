import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pds_front/app/pages/dashboard/admin_login_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/posts_page.dart';


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
        'Dados salvos no login: $userData'); 

    await Future.delayed(const Duration(seconds: 2)); 
    if (userData != null) {
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
