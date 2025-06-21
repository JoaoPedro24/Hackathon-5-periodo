import 'package:flutter/material.dart';

class TurmaSelector extends StatelessWidget {
  final List<Map<String, dynamic>> turmas;
  final Map<String, dynamic>? selectedTurma;
  final Function(Map<String, dynamic>?) onChanged;

  const TurmaSelector({
    super.key,
    required this.turmas,
    required this.selectedTurma,
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
            'Selecione a Turma:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<Map<String, dynamic>>(
            value: selectedTurma,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Escolha uma turma',
            ),
            items: turmas.map((turma) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: turma,
                child: Text(turma['nome'] ?? 'Turma sem nome'),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

