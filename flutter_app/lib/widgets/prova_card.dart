// lib/widgets/prova_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Importe o go_router
import '../models/prova_model.dart'; // Importa o modelo de prova

class ProvaCard extends StatelessWidget {
  final ProvaModel prova;

  // O parâmetro onVisualizar não é mais necessário aqui, pois a navegação é interna
  // final VoidCallback? onVisualizar;

  const ProvaCard({
    super.key,
    required this.prova,
    // Remova o onVisualizar do construtor
    // this.onVisualizar,
  });

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
            // Informações da prova
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
            // Botão de Visualizar
            ElevatedButton(
              // Usa context.go() para navegar para a rota GoRouter, passando o ID da prova
              onPressed: () {
                context.go('/visualizarP/${prova.id}');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
