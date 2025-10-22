import 'package:flutter/material.dart';

class TelaDetalhesAnimal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String>? animal =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    if (animal == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Detalhes do Animal')),
        body: Center(child: Text('Nenhum animal selecionado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(animal['nome']!)),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.pets, size: 100, color: Colors.teal),
            SizedBox(height: 16),
            _buildDetail('Nome', animal['nome']!),
            _buildDetail('Espécie', animal['especie']!),
            _buildDetail('Raça', animal['raca'] ?? '-'),
            _buildDetail('Porte', animal['porte']!),
            _buildDetail('Status', animal['status']!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
