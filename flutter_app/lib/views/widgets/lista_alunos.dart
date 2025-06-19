import 'package:flutter/material.dart';

class ListaAlunos extends StatelessWidget {
  final List<Map<String, dynamic>> alunos;

  const ListaAlunos({super.key, required this.alunos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: alunos.length,
      itemBuilder: (context, index) {
        final aluno = alunos[index];
        return ListTile(
          title: Text(aluno['nome']),
          subtitle: Text(
            'Matrícula: ${aluno['matricula']} - Tempo: ${aluno['tempo']}',
          ),
        );
      },
    );
  }
}
