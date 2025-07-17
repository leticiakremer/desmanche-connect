import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';
import 'package:pds_front/config.dart';

void main() {
  const env = String.fromEnvironment('ENV', defaultValue: 'development');

  AppConfig.init(
    env == 'production'
        ? AppEnvironment.production
        : AppEnvironment.development,
  );
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouteManager.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF171821),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color(0xFF007BFF), // 🔵 fundo da seleção
          selectionHandleColor: Colors.white, // ⚪ alças da seleção
          cursorColor: Color(0xFF007BFF), // 🔵 cursor piscando
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1F1F2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF007BFF)),
          ),
        ),
      ),
    );
  }
}
