import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _abrirWhatsApp() async {
    final whatsappUrl = Uri.parse(
      "https://wa.me/555195173628?text=Olá!%20Tenho%20interesse%20em%20uma%20peça%20ou%20veículo%20do%20site%20e%20gostaria%20de%20mais%20informações.",
    );
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF007BFF);
    const escuro = Color(0xFF171821);
    const cardColor = Color(0xFF1F1F2A);

    return Scaffold(
      backgroundColor: escuro,
      appBar: AppBar(
        title: const Text('Atendimento'),
        centerTitle: true,
        backgroundColor: escuro,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.support_agent,
                      size: 80, color: Colors.white),
                  const SizedBox(height: 24),
                  const Text(
                    'Quer saber mais sobre uma peça?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Entre em contato pelo WhatsApp e tire suas dúvidas sobre peças e veículos anunciados. '
                    'Nossa equipe está pronta para atender você!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _abrirWhatsApp,
                    icon: const Icon(Icons.chat, color: azul),
                    label: const Text(
                      'Quero falar pelo WhatsApp',
                      style: TextStyle(fontSize: 16, color: azul),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: azul,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Column(
                    children: [
                      Icon(Icons.access_time_rounded,
                          color: Colors.white70, size: 28),
                      SizedBox(height: 8),
                      Text(
                        'Atendimento de segunda a sexta,\ndas 9h às 18h',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Respondemos em até 2 horas úteis.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
