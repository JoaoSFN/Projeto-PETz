import 'package:flutter/material.dart';

class TelaListaAnimais extends StatelessWidget {
  final List<Map<String, String>> animais = [
    {
      'nome': 'Rex',
      'especie': 'Cachorro',
      'porte': 'Grande',
      'status': 'Disponível',
    },
    {
      'nome': 'Mimi',
      'especie': 'Gato',
      'porte': 'Pequeno',
      'status': 'Disponível',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animais Disponíveis')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: animais.length,
          itemBuilder: (context, index) {
            final animal = animais[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.pets, size: 40, color: Colors.teal),
                title: Text(animal['nome']!, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${animal['especie']} - ${animal['porte']}'),
                trailing: Chip(
                  label: Text(animal['status']!),
                  backgroundColor: animal['status'] == 'Disponível' ? Colors.green[200] : Colors.red[200],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/detalhesAnimal', arguments: animal);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
