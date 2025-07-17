import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/widgets/debounce_input.dart';

class PublicHeader extends StatelessWidget {
  final void Function(String) onSearchChanged;
  final String? currentPath;

  const PublicHeader(
      {super.key, required this.onSearchChanged, this.currentPath});

  bool isSelected(String route) => currentPath == route;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF1A1B23), // Fundo escuro
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🏷️ Título
              const Text(
                "Desmanche Connect",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              // 🔍 Campo de busca
              SizedBox(
                width: 450,
                child: DebounceInput(
                  label: "Buscar postagem",
                  debounceDuration: const Duration(milliseconds: 500),
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.white54), // 🔍 ícone de busca
                    hintText: 'Pesquisar peças para o seu veículo',
                    filled: true,
                    fillColor: const Color(0xFF252A3A),
                    hintStyle: const TextStyle(color: Colors.white54),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF3A3F55),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF007BFF),
                        width: 1.5,
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              // 📌 Links de navegação
              Row(
                children: [
                  _HeaderNavItem(
                    title: "Início",
                    route: "/",
                    selected: isSelected("/"),
                  ),
                  const SizedBox(width: 12),
                  _HeaderNavItem(
                    title: "Quem somos",
                    route: "/about",
                    selected: isSelected("/about"),
                  ),
                  const SizedBox(width: 12),
                  _HeaderNavItem(
                    title: "Contato",
                    route: "/help",
                    selected: isSelected("/help"),
                  ),
                ],
              )
            ],
          ),
        ),

        // 🔻 Divider inferior
        const Divider(
          height: 1,
          thickness: 0.4,
          color: Color(0xFF3A3F55),
        ),
      ],
    );
  }
}

class _HeaderNavItem extends StatelessWidget {
  final String title;
  final String route;
  final bool selected;

  const _HeaderNavItem({
    required this.title,
    required this.route,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF007BFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
