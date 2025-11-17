import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petz/database/db_animais.dart';

class TelaCadastroAnimal extends StatefulWidget {
  @override
  _TelaCadastroAnimalState createState() => _TelaCadastroAnimalState();
}

class _TelaCadastroAnimalState extends State<TelaCadastroAnimal> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  String idadeTipo = "anos";
  String porte = "Pequeno";

  File? imagemSelecionada;

  Future<void> _escolherImagem() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagemSelecionada = File(image.path);
      });
    }
  }

  Future<void> _salvarAnimal() async {
    if (nomeController.text.isEmpty ||
        idadeController.text.isEmpty ||
        racaController.text.isEmpty ||
        telefoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preencha todos os campos obrigatórios corretamente."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final animal = {
      'nome': nomeController.text,
      'idade': "${idadeController.text} $idadeTipo",
      'raca': racaController.text,
      'porte': porte,
      'peso': pesoController.text.isEmpty ? null : pesoController.text,
      'telefone': telefoneController.text,
      'fotoPath': imagemSelecionada?.path
    };

    await DatabaseHelperAnimais.instance.insertAnimal(animal);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5D8),
      appBar: AppBar(
        title: const Text("Cadastrar Animal"),
        backgroundColor: const Color(0xFF4E342E),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _escolherImagem,
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEBE9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6D4C41)),
                  image: imagemSelecionada != null
                      ? DecorationImage(
                    image: FileImage(imagemSelecionada!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: imagemSelecionada == null
                    ? const Icon(Icons.camera_alt,
                    size: 40, color: Color(0xFF6D4C41))
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Nome
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome do animal"),
            ),
            const SizedBox(height: 16),

            // Raça
            TextField(
              controller: racaController,
              decoration: InputDecoration(labelText: "Raça do animal"),
            ),
            const SizedBox(height: 16),

            // Idade + Tipo
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: idadeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Idade"),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: idadeTipo,
                  items: ["meses", "anos"].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      idadeTipo = v!;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 16),

            // Peso (opcional)
            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Peso (opcional)",
              ),
            ),
            const SizedBox(height: 16),

            // Porte
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Porte"),
              value: porte,
              items: ["Pequeno", "Médio", "Grande"].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  porte = v!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Telefone
            TextField(
              controller: telefoneController,
              keyboardType: TextInputType.number,
              maxLength: 11,
              decoration: InputDecoration(
                labelText: "Telefone do anunciante (somente números)",
                counterText: "",
              ),
            ),
            const SizedBox(height: 24),

            // Botão salvar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvarAnimal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Salvar Animal"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
