import 'package:flutter/material.dart';
import 'package:pds_front/app/widgets/debounce_input.dart';
import 'package:pds_front/app/widgets/header_widget.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          title: 'Usuários',
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB2F1F0),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Criar usuário"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DebounceInput(
            label: "Buscar usuário",
            debounceDuration: const Duration(milliseconds: 500),
            onChanged: (value) {
              setState(() => {});
            },
          ),
        ),
        Expanded(
          child: Placeholder(),
        ),
      ],
    );
  }
}
