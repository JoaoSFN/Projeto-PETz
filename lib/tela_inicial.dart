import 'package:flutter/material.dart';

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bem-vindo ao PETz!',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: alturaTela * 0.01),

                  Text(
                    'Encontre seu novo melhor amigo e transforme vidas!',
                    style: TextStyle(
                      fontSize: alturaTela > 700 ? 18 : 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4E342E),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: alturaTela * 0.02),

                  Image.asset(
                    'assets/imagens/cachorro_logo.png',
                    width: alturaTela * 0.4,
                    height: alturaTela * 0.4,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: alturaTela * 0.03),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastroAdotante');
                    },
                    icon: Icon(Icons.person_add, color: Colors.white),
                    label: Text('Cadastrar Adotante'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D4C41), // marrom meio escuro
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    ),
                  ),

                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastroAnimal');
                    },
                    icon: Icon(Icons.pets, color: Colors.white),
                    label: Text('Cadastrar Animal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D4C41),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    ),
                  ),

                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/listaAnimais');
                    },
                    icon: Icon(Icons.list, color: Colors.white),
                    label: Text('Ver Animais Disponíveis'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D4C41),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
