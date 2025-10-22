import 'package:flutter/material.dart';
import 'tela_inicial.dart';
import 'tela_cadastro_adotante.dart';
import 'tela_cadastro_animal.dart';
import 'tela_lista_animais.dart';
import 'tela_detalhes_animal.dart';

void main() {
  runApp(AdocaoAnimaisApp());
}

class AdocaoAnimaisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoção de Animais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFFA726), // laranja suave
        scaffoldBackgroundColor: Color(0xFFFFF8E1), // fundo creme
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFA726),
          centerTitle: true,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFA726),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF4E342E)),
          bodyLarge: TextStyle(color: Color(0xFF4E342E)),
          titleLarge: TextStyle(color: Color(0xFF4E342E)),
          titleMedium: TextStyle(color: Color(0xFF4E342E)),
          labelLarge: TextStyle(color: Color(0xFF4E342E)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TelaInicial(),
        '/cadastroAdotante': (context) => TelaCadastroAdotante(),
        '/cadastroAnimal': (context) => TelaCadastroAnimal(),
        '/listaAnimais': (context) => TelaListaAnimais(),
        '/detalhesAnimal': (context) => TelaDetalhesAnimal(),
      },
    );
  }
}
