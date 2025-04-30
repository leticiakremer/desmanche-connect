import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFFFF6600), // fundo laranja (ou a cor que quiser)
    body: Center(
      child: Image.asset(
        'assets/splash/logo.png',
        width: MediaQuery.of(context).size.width * 0.8,
        fit: BoxFit.contain,
      ),
    ),
  );
}

}