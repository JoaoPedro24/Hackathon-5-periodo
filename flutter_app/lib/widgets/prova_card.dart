import 'package:flutter/material.dart';

class ProvaCard extends StatelessWidget {
  final Map<String, dynamic> prova;
  final VoidCallback onVisualizar;

  const ProvaCard({super.key, required this.prova, required this.onVisualizar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: prova['cor'],
          child: Icon(prova['icone'], color: Colors.white),
        ),
        title: Text(prova['titulo'], style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${prova['disciplina']} - ${prova['data']}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        trailing: ElevatedButton(
          onPressed: onVisualizar,
          child: const Text('Visualizar'),
        ),
      ),
    );
  }
}
