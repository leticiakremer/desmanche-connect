import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  void _abrirWhatsApp() async {
    final whatsappUrl = Uri.parse(
      "https://wa.me/555195173628?text=Olá!%20Gostaria%20de%20saber%20mais%20sobre%20a%20autodemolidora.",
    );
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  void _abrirMaps() async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=Av.+Arroio+do+Sal,+1510,+Arroio+do+Sal+-+RS,+95585-000",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
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
        title: const Text('Quem Somos'),
        centerTitle: true,
        backgroundColor: escuro,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/banner3.jpeg',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(
                    color: Colors.white.withOpacity(0.2),
                    thickness: 1.2,
                    height: 24,
                  ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.directions_car_filled_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sobre a Autodemolidora',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Somos uma autodemolidora credenciada pelo DETRAN (CDV00764), '
                    'atuando com responsabilidade desde 2010 em Arroio do Sal - RS. '
                    'Todas as peças possuem procedência e são legalmente registradas. '
                    'Nossa missão é oferecer segurança, confiança e qualidade para quem precisa de peças automotivas usadas.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      hoverColor: Colors.white.withOpacity(0.05),
                      onTap: _abrirMaps,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.white70),
                            const SizedBox(width: 8),
                            const Text(
                              'Av. Arroio do Sal, 1510 - Arroio do Sal - RS, 95585-000',
                              style: TextStyle(
                                color: azul,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _abrirWhatsApp,
                    icon: const Icon(Icons.chat, color: azul),
                    label: const Text(
                      'Fale conosco pelo WhatsApp',
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
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
