import 'package:flutter/material.dart';

class TelaCadastroAdotante extends StatefulWidget {
  @override
  _TelaCadastroAdotanteState createState() => _TelaCadastroAdotanteState();
}

class _TelaCadastroAdotanteState extends State<TelaCadastroAdotante> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Adotante')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTitle(),
              SizedBox(height: 20),
              _buildTextField(_nomeController, 'Nome completo'),
              _buildTextField(_cpfController, 'CPF', keyboardType: TextInputType.number),
              _buildTextField(_enderecoController, 'Endereço'),
              _buildTextField(_telefoneController, 'Telefone', keyboardType: TextInputType.phone),
              _buildTextField(_emailController, 'E-mail', keyboardType: TextInputType.emailAddress),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Adotante cadastrado com sucesso!')),
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
        Icon(Icons.person, size: 80, color: Colors.teal),
        SizedBox(height: 16),
        Text(
          'Informe os dados do adotante',
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
