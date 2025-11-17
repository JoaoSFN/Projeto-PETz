import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petz/database/db_animais.dart';

class TelaEditaAnimal extends StatefulWidget {
  final Map<String, dynamic> animal;

  TelaEditaAnimal({required this.animal});

  @override
  _TelaEditaAnimalState createState() => _TelaEditaAnimalState();
}

class _TelaEditaAnimalState extends State<TelaEditaAnimal> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  String idadeTipo = "anos";
  String porte = "Pequeno";
  File? imagemSelecionada;

  @override
  void initState() {
    super.initState();

    nomeController.text = widget.animal['nome'];
    pesoController.text = widget.animal['peso']?.toString() ?? "";
    racaController.text = widget.animal['raca'] ?? "";
    telefoneController.text = widget.animal['telefone'] ?? "";

    String idadeCompleta = widget.animal['idade'] ?? "";
    if (idadeCompleta.contains("meses")) {
      idadeTipo = "meses";
      idadeController.text = idadeCompleta.replaceAll("meses", "").trim();
    } else {
      idadeTipo = "anos";
      idadeController.text = idadeCompleta.replaceAll("anos", "").trim();
    }

    porte = widget.animal['porte'] ?? "Pequeno";

    if (widget.animal['fotoPath'] != null &&
        widget.animal['fotoPath'].toString().isNotEmpty) {
      imagemSelecionada = File(widget.animal['fotoPath']);
    }
  }

  Future<void> _escolherImagem() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagemSelecionada = File(image.path);
      });
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (nomeController.text.isEmpty ||
        idadeController.text.isEmpty ||
        racaController.text.isEmpty ||
        telefoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Preencha todos os campos obrigatórios."),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final animalAtualizado = {
      'id': widget.animal['id'],
      'nome': nomeController.text,
      'idade': "${idadeController.text} $idadeTipo",
      'raca': racaController.text,
      'porte': porte,
      'peso': pesoController.text.isEmpty ? null : pesoController.text,
      'telefone': telefoneController.text,
      'fotoPath': imagemSelecionada?.path ?? widget.animal['fotoPath'],
    };

    await DatabaseHelperAnimais.instance.updateAnimal(animalAtualizado);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF8F3ED),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text("Alterações Salvas"),
          ],
        ),
        content: const Text(
          "As informações do animal foram atualizadas com sucesso!",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: Colors.green)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }

  Future<void> _excluirAnimal() async {
    bool confirmar = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.delete_forever, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text("Excluir Animal"),
          ],
        ),
        content: const Text(
          "Tem certeza que deseja excluir este animal? Esta ação não pode ser desfeita.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar", style: TextStyle(color: Colors.brown)),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Excluir", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await DatabaseHelperAnimais.instance.deleteAnimal(widget.animal['id']);
      Navigator.pop(context, true);
    }
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF7EFE7),
      labelStyle: const TextStyle(color: Color(0xFF6D4C41)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFBCAAA4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6D4C41), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5D8),
      appBar: AppBar(
        title: const Text("Editar Animal"),
        backgroundColor: const Color(0xFF4E342E),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: const Color(0xFFFFFBF8),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _escolherImagem,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEBE9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.shade200,
                          blurRadius: 6,
                        )
                      ],
                      image: imagemSelecionada != null
                          ? DecorationImage(
                        image: FileImage(imagemSelecionada!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: imagemSelecionada == null
                        ? const Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Color(0xFF6D4C41),
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: nomeController,
                  decoration: _inputStyle("Nome do animal"),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: racaController,
                  decoration: _inputStyle("Raça do animal"),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: idadeController,
                        keyboardType: TextInputType.number,
                        decoration: _inputStyle("Idade"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7EFE7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFBCAAA4)),
                      ),
                      child: DropdownButton<String>(
                        value: idadeTipo,
                        underline: const SizedBox(),
                        items: ["meses", "anos"].map((e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            idadeTipo = v!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: _inputStyle("Peso (opcional)"),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: _inputStyle("Porte"),
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

                TextField(
                  controller: telefoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  decoration: _inputStyle("Telefone do anunciante").copyWith(
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 28),

                // BOTÃO SALVAR
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _salvarAlteracoes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D4C41),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Salvar Alterações",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // BOTÃO EXCLUIR
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _excluirAnimal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Excluir Animal",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
