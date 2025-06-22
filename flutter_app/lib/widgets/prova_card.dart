import 'package:flutter/material.dart';
import '../models/prova_model.dart';

class ProvaCard extends StatelessWidget {
  final ProvaModel prova;
  final VoidCallback? onVisualizar;

  const ProvaCard({
    super.key,
    required this.prova,
    this.onVisualizar, // parâmetro opcional
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(prova.nome, style: theme.textTheme.titleMedium),
        subtitle: Text('Disciplina: ${prova.disciplina}\nTurma: ${prova.turma}'),
        trailing: Text('${prova.valorTotal.toStringAsFixed(2)} pts'),
        onTap: onVisualizar,
      ),
    );
  }
}
