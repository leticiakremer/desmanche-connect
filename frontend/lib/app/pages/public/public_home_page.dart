import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicHomePage extends StatefulWidget {
  const PublicHomePage({super.key});

  @override
  State<PublicHomePage> createState() => _PublicHomePageState();
}

class _PublicHomePageState extends State<PublicHomePage> {
  void _openWhatsapp() async {
    final Uri url = Uri.parse(
        "https://wa.me/5551991231013?text=Oi,%20tudo%20bem?%20Poderia%20me%20ajudar%20com%20uma%20informa%C3%A7%C3%A3o?");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir o WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Expanded(child: Placeholder()),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "Dúvidas? Fale conosco!",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: _openWhatsapp,
                backgroundColor: Colors.green,
                mini: true,
                tooltip: "Contato via WhatsApp",
                child: const Icon(
                  Icons.phone,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
