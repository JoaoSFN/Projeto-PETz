import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petz/database/db_animais.dart';
import 'tela_cadastro_animal.dart';
import 'tela_detalhes_animal.dart';
import 'tela_edita_animal.dart';

class TelaListaAnimais extends StatefulWidget {
  @override
  _TelaListaAnimaisState createState() => _TelaListaAnimaisState();
}

class _TelaListaAnimaisState extends State<TelaListaAnimais> {
  List<Map<String, dynamic>> animais = [];

  bool isDoador = false;
  String nomeAdotante = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is Map<String, dynamic>) {
      isDoador = args['isDoador'] == 1;
      nomeAdotante = args['nome'] ?? "";
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
  }

  Future<void> _carregarAnimais() async {
    final dados = await DatabaseHelperAnimais.instance.getAnimais();
    setState(() {
      animais = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4E342E),
        title: const Text(
          "Animais para Adoção",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // -----------------------------------------------------------
      //    FAB aparece só para doadores
      // -----------------------------------------------------------
      floatingActionButton: isDoador
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF4E342E),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaCadastroAnimal()),
          );

          if (result != null) {
            _carregarAnimais();
          }
        },
      )
          : null,

      body: animais.isEmpty
          ? const Center(
        child: Text(
          "Nenhum animal cadastrado.",
          style: TextStyle(fontSize: 18, color: Color(0xFF5D4037)),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: animais.length,
        itemBuilder: (context, index) {
          final animal = animais[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: const Color(0xFFFFFFFF),

            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),

                  leading: animal['fotoPath'] != null &&
                      animal['fotoPath'].toString().isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(animal['fotoPath']),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.pets,
                      size: 48, color: Color(0xFF8D6E63)),

                  title: Text(
                    animal['nome'] ?? 'Sem nome',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4E342E),
                    ),
                  ),

                  subtitle: Text(
                    "${animal['raca'] ?? 'Raça indefinida'} • ${animal['idade'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6D4C41),
                    ),
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Color(0xFF8D6E63)),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TelaDetalhesAnimal(animal: animal),
                      ),
                    );
                  },
                ),

                // -------------------------------------------------
                //    BOTÃO EDITAR → só aparece se for doador
                // -------------------------------------------------
                if (isDoador)
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(
                        right: 12, bottom: 12, top: 0),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TelaEditaAnimal(animal: animal),
                          ),
                        );

                        if (result != null) {
                          _carregarAnimais();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.edit,
                                color: Colors.white, size: 20),
                            SizedBox(width: 6),
                            Text(
                              "Editar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
