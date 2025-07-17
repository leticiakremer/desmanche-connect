import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PublicFooter extends StatelessWidget {
  const PublicFooter({super.key});

  static const footerColor = Color(0xFF171821);

  static const titleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontSize: 16,
  );

  static const itemStyle = TextStyle(
    color: Colors.white60,
    fontSize: 13.5,
  );

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location = GoRouterState.of(context).uri.toString();

    return Column(
      children: [
        const Divider(color: Colors.white12, thickness: 0.5),

        Container(
          width: double.infinity,
          color: footerColor,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24), 
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 700;

                  return isSmall
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _aboutColumn(),
                            const SizedBox(height: 16), 
                            _navColumn(router, location),
                            const SizedBox(height: 16),
                            _supportColumn(router),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _aboutColumn(),
                            _navColumn(router, location),
                            _supportColumn(router),
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _aboutColumn() {
    return const SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Desmanche Connect', style: titleStyle),
          SizedBox(height: 8), 
          Text(
            'Conectando você às melhores peças e veículos para o seu veículo',
            style: itemStyle,
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _navColumn(GoRouter router, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Navegação', style: titleStyle),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (location != '/') {
              router.go('/');
            }
          },
          child: const Text('Início', style: itemStyle),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => router.go('/about'),
          child: const Text('Quem somos', style: itemStyle),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _supportColumn(GoRouter router) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Suporte', style: titleStyle),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => router.go('/help'),
          child: const Text('Contato', style: itemStyle),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
