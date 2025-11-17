import 'package:flutter/material.dart';
import 'database/db.dart';

class TelaLoginAdotante extends StatefulWidget {
  @override
  _TelaLoginAdotanteState createState() => _TelaLoginAdotanteState();
}

class _TelaLoginAdotanteState extends State<TelaLoginAdotante> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cpfController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E9D7),
      appBar: AppBar(
        backgroundColor: Color(0xFF5D4037),
        title: Text(
          "Login do Adotante",
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
              SizedBox(height: 20),
              Text(
                "Entre com seu CPF e senha",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4E342E),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28),
              TextFormField(
                controller: cpfController,
                cursorColor: Color(0xFF5D4037),
                style: TextStyle(color: Color(0xFF4E342E)),
                decoration: InputDecoration(
                  labelText: "CPF",
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
                ),
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
                      mostrarSenha
                          ? Icons.visibility_off
                          : Icons.visibility,
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
                      final cpf = cpfController.text.trim();
                      final senha = senhaController.text.trim();

                      // 🔥 Agora retorna todos os dados, inclusive isDoador
                      final adotante = await DatabaseHelper.instance
                          .autenticarAdotanteComTipo(cpf, senha);

                      if (adotante != null) {
                        // Salva tipo de usuário na navegação
                        Navigator.pushReplacementNamed(
                          context,
                          '/listaAnimais',
                          arguments: {
                            'isDoador': adotante['isDoador'],
                            'nome': adotante['nome'],
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("CPF ou senha incorretos"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastroAdotante');
                },
                child: Text(
                  "Não possui conta? Cadastre-se",
                  style: TextStyle(
                    color: Color(0xFF5D4037),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
