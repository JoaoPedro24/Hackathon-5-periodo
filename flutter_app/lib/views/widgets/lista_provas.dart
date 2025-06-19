import 'package:flutter/material.dart';

class ListaProvas extends StatelessWidget {
  final List<Map<String, dynamic>> provas;
  final void Function(Map<String, dynamic>) onSelecionar;

  const ListaProvas({
    super.key,
    required this.provas,
    required this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final prova = provas[index];
            return ListTile(
              title: Text(prova['titulo']),
              subtitle: Text(prova['disciplina']),
              onTap: () => onSelecionar(prova),
            );
          },
          childCount: provas.length,
        ),
      ),
    );
  }
}
