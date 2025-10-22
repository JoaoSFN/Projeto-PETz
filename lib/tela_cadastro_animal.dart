import 'package:flutter/material.dart';

class TelaCadastroAnimal extends StatefulWidget {
  @override
  _TelaCadastroAnimalState createState() => _TelaCadastroAnimalState();
}

class _TelaCadastroAnimalState extends State<TelaCadastroAnimal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _racaController = TextEditingController();
  final _especieController = TextEditingController();
  final _porteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Animal')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTitle(),
              SizedBox(height: 20),
              _buildTextField(_nomeController, 'Nome'),
              _buildTextField(_idadeController, 'Idade', keyboardType: TextInputType.number),
              _buildTextField(_pesoController, 'Peso', keyboardType: TextInputType.number),
              _buildTextField(_racaController, 'Raça'),
              _buildTextField(_especieController, 'Espécie'),
              _buildTextField(_porteController, 'Porte'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Animal cadastrado com sucesso!')),
                    );
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Icon(Icons.pets, size: 80, color: Colors.teal),
        SizedBox(height: 16),
        Text(
          'Informe os dados do animal',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}
