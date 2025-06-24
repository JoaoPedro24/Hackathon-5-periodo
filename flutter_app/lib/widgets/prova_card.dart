import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/prova_model.dart';

class ProvaCard extends StatelessWidget {
  final ProvaModel prova;

  const ProvaCard({super.key, required this.prova});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prova.nome,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Disciplina: ${prova.disciplina}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Turma: ${prova.turma}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Valor Total: ${prova.valorTotal.toStringAsFixed(2)} pts',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(

              onPressed: () {
                // context.go() utiliza-se para navegar para a rota GoRouter, passando o ID da prova
                context.go('/visualizar/${prova.id}');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 14),
              ),
              child: const Text('Visualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
