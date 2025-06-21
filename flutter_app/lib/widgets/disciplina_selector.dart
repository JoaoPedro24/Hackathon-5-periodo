import 'package:flutter/material.dart';

class DisciplinaSelector extends StatelessWidget {
  final List<Map<String, dynamic>> disciplinas;
  final Map<String, dynamic>? selectedDisciplina;
  final Function(Map<String, dynamic>?) onChanged;

  const DisciplinaSelector({
    super.key,
    required this.disciplinas,
    required this.selectedDisciplina,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione a Disciplina:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<Map<String, dynamic>>(
            value: selectedDisciplina,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Escolha uma disciplina',
            ),
            items: disciplinas.map((disciplina) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: disciplina,
                child: Text(disciplina['nome'] ?? 'Disciplina sem nome'),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

