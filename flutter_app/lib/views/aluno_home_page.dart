import 'package:flutter/material.dart';

class AlunoHomePage extends StatefulWidget {
  const AlunoHomePage({super.key});

  @override
  State<AlunoHomePage> createState() => _AlunoHomeState();
}

class _AlunoHomeState extends State<AlunoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sucesso tela Aluno'),
      ),
    );
  }
}