import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaDetalhesAnimal extends StatelessWidget {
  final Map<String, dynamic> animal;

  TelaDetalhesAnimal({required this.animal});

  void _abrirWhatsapp(BuildContext context) async {
    final telefone = animal['telefone'];

    if (telefone == null || telefone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Telefone do anunciante não informado")),
      );
      return;
    }

    String numeroLimpo = telefone.replaceAll(RegExp(r'[^0-9]'), '');

    String nomeAnimal = animal['nome'] ?? "seu animal";

    String mensagem = Uri.encodeComponent(
        "Olá, faço parte da comunidade PETz e gostaria de mais informações sobre o(a) $nomeAnimal na qual encontrei no app!"
    );

    final Uri url = Uri.parse("https://wa.me/55$numeroLimpo?text=$mensagem");

    final bool aberto = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!aberto) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Não foi possível abrir o WhatsApp")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4E342E),
        title: Text(
          animal['nome'] ?? "Detalhes do Animal",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade300,
                  image: animal['fotoPath'] != null
                      ? DecorationImage(
                    image: FileImage(File(animal['fotoPath'])),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: animal['fotoPath'] == null
                    ? const Icon(Icons.pets, size: 80, color: Colors.brown)
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              animal['nome'] ?? "Sem nome",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E342E),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "${animal['raca'] ?? 'Raça indefinida'} • ${animal['idade'] ?? ''}",
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF6D4C41),
              ),
            ),

            const SizedBox(height: 20),

            _infoCard("Porte", animal['porte'] ?? "Não informado"),
            const SizedBox(height: 12),
            _infoCard("Peso", animal['peso']?.toString() ?? "Não informado"),
            const SizedBox(height: 12),
            _infoCard("Telefone do anunciante", animal['telefone'] ?? "Não informado"),

            const SizedBox(height: 24),

            const Text(
              "Descrição:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4E342E)),
            ),

            const SizedBox(height: 6),

            Text(
              animal['descricao'] ?? "Sem descrição",
              style: const TextStyle(fontSize: 16, color: Color(0xFF5D4037)),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _abrirWhatsapp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Adotar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String titulo, String valor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF8D6E63),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF4E342E),
            ),
          ),
        ],
      ),
    );
  }
}
