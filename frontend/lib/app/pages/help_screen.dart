import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _abrirWhatsApp() async {
    final whatsappUrl = Uri.parse(
      "https://wa.me/555195173628?text=Oi,%20tudo%20bem%3F%20Poderia%20me%20ajudar%20com%20uma%20informa%C3%A7%C3%A3o%3F.",
    );
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color.fromARGB(255, 145, 228, 226);
    const escuro = Color(0xFF171821);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
        centerTitle: true,
        backgroundColor: escuro,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline,
                  size: 120,
                  color: escuro,
                ),
                const SizedBox(height: 24),
                Text(
                  'Precisa de Ajuda?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: escuro,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Ficou com alguma dúvida ou precisa de uma informação?\n'
                  'Entre em contato agora mesmo pelo WhatsApp!',
                  style: TextStyle(
                    fontSize: 16,
                    color: escuro,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _abrirWhatsApp,
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text(
                    'Fale conosco no WhatsApp',
                    style: TextStyle(fontSize: 16, color: azul),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: escuro,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
