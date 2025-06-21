import 'package:flutter/material.dart';

class FiltroDisciplina extends StatelessWidget {
  final String? valorSelecionado;
  final List<String> opcoes;
  final void Function(String?) onChanged;

  const FiltroDisciplina({
    super.key,
    required this.valorSelecionado,
    required this.opcoes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: valorSelecionado,
      decoration: InputDecoration(
        labelText: 'Filtrar por disciplina',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.book),
      ),
      isExpanded: true,
      items: [
        const DropdownMenuItem(value: null, child: Text('Todas')),
        ...opcoes.map((disciplina) => DropdownMenuItem(
              value: disciplina,
              child: Text(disciplina),
            )),
      ],
      onChanged: onChanged,
    );
  }
}
