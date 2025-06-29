import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  void _abrirWhatsApp() async {
    final whatsappUrl = Uri.parse(
      "https://wa.me/555195173628?text=Oi,%20tudo%20bem%3F%20Poderia%20me%20ajudar%20com%20uma%20informa%C3%A7%C3%A3o%3F",
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
        title: const Text('Sobre Nós'),
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
                Image.asset(
                  'assets/logo2.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  'Quem Somos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: escuro,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Somos uma empresa autodemolidora credenciada pelo DETRAN, '
                  'atuando com dedicação e responsabilidade desde 2010 em Arroio do Sal-RS. '
                  'Nossa missão é garantir o descarte correto e sustentável dos veículos, '
                  'oferecendo segurança e confiança aos nossos clientes.',
                  style: TextStyle(
                    fontSize: 16,
                    color: escuro,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Divider(color: azul.withOpacity(0.6), thickness: 1),
                const SizedBox(height: 16),
                _buildEnderecoInfo(azul, escuro),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _abrirWhatsApp,
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text(
                    'Fale conosco! Será um prazer atender você',
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

  Widget _buildEnderecoInfo(Color iconColor, Color textColor) {
    return Column(
      children: [
        _buildEnderecoRow(Icons.location_on_outlined,
            'Avenida Arroio do Sal, 1510', iconColor, textColor),
        _buildEnderecoRow(Icons.markunread_mailbox_outlined, 'CEP: 95.585-000',
            iconColor, textColor),
        _buildEnderecoRow(Icons.location_city_outlined, 'Arroio do Sal - RS',
            iconColor, textColor),
      ],
    );
  }

  Widget _buildEnderecoRow(
      IconData icon, String texto, Color iconColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(fontSize: 15, color: textColor.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }
}
