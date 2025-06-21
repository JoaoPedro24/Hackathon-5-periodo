import 'package:flutter/material.dart';

class AlunoCard extends StatelessWidget {
  final String nome;
  final String? nota;

  const AlunoCard({super.key, required this.nome, this.nota});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nome, style: Theme.of(context).textTheme.bodyMedium),
          Text(nota ?? '---', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
