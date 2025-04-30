import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ferro Velho Online'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de busca
            TextField(
              decoration: InputDecoration(
                hintText: 'Procure sua peça...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categorias
            const Text(
              'Categorias',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(Icons.engineering, 'Motor'),
                  _buildCategoryItem(Icons.tire_repair, 'Rodas'),
                  _buildCategoryItem(Icons.chair_alt, 'Interior'),
                  _buildCategoryItem(Icons.settings, 'Acessórios'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de peças
            const Text(
              'Peças disponíveis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildPieceItem('Parachoque Corsa 2010', 'Bom estado', 150),
                  _buildPieceItem('Motor Gol 1.0', 'Revisado', 1200),
                  _buildPieceItem('Roda Fiat Aro 15', 'Usada', 250),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blueGrey[800]),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildPieceItem(String name, String condition, double price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.car_repair, size: 40),
        title: Text(name),
        subtitle: Text(condition),
        trailing: Text('R\$ ${price.toStringAsFixed(2)}'),
        onTap: () {
          // Aqui você pode navegar para a tela de detalhes da peça
        },
      ),
    );
  }
}
