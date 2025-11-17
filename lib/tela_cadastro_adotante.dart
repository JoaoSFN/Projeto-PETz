import 'package:flutter/material.dart';
import 'database/db.dart';

class TelaCadastroAdotante extends StatefulWidget {
  @override
  _TelaCadastroAdotanteState createState() => _TelaCadastroAdotanteState();
}

class _TelaCadastroAdotanteState extends State<TelaCadastroAdotante> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool mostrarSenha = false;

  bool isDoador = false; // manter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E9D7),
      appBar: AppBar(
        backgroundColor: Color(0xFF5D4037),
        title: Text(
          "Cadastro de Adotante",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Informações do Adotante",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4E342E),
                ),
              ),
              SizedBox(height: 28),

              _inputCustom("Nome Completo", nomeController),
              SizedBox(height: 18),

              _inputCustom("CPF", cpfController),
              SizedBox(height: 18),

              _inputCustom("Endereço", enderecoController),
              SizedBox(height: 18),

              _inputCustom("Telefone", telefoneController),
              SizedBox(height: 18),

              CheckboxListTile(
                title: Text(
                  "Quero colocar animais para adoção",
                  style: TextStyle(
                    color: Color(0xFF4E342E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: isDoador,
                activeColor: Color(0xFF5D4037),
                onChanged: (value) {
                  setState(() {
                    isDoador = value ?? false;
                  });
                },
              ),
              SizedBox(height: 18),

              TextFormField(
                controller: senhaController,
                obscureText: !mostrarSenha,
                cursorColor: Color(0xFF5D4037),
                style: TextStyle(color: Color(0xFF4E342E)),
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Color(0xFF4E342E),
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: Color(0xFFFAF9F7),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                    BorderSide(color: Color(0xFF5D4037).withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                    BorderSide(color: Color(0xFF5D4037), width: 1.8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarSenha ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF5D4037),
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarSenha = !mostrarSenha;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5D4037),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {

                      final senhaHash = DatabaseHelper.instance
                          .hashPassword(senhaController.text.trim());

                      final Map<String, dynamic> adotante = {
                        'nome': nomeController.text.trim(),
                        'cpf': cpfController.text.trim(),
                        'endereco': enderecoController.text.trim(),
                        'telefone': telefoneController.text.trim(),
                        'senha': senhaHash,
                        'isDoador': isDoador ? 1 : 0,
                      };

                      try {
                        await DatabaseHelper.instance.insertAdotante(adotante);

                        // 🔥 LOGIN AUTOMÁTICO
                        final usuarioLogado =
                        await DatabaseHelper.instance.autenticarAdotanteComTipo(
                            adotante['cpf'], senhaController.text.trim());

                        // 🔥 REDIRECIONA DIRETO PARA LISTA
                        Navigator.pushReplacementNamed(
                          context,
                          '/listaAnimais',
                          arguments: {
                            'isDoador': usuarioLogado!['isDoador'],
                            'nome': usuarioLogado['nome'],
                          },
                        );

                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erro: CPF já cadastrado"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputCustom(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      cursorColor: Color(0xFF5D4037),
      style: TextStyle(color: Color(0xFF4E342E)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Color(0xFF4E342E),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Color(0xFFFAF9F7),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFF5D4037).withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFF5D4037), width: 1.8),
        ),
      ),
    );
  }
}
