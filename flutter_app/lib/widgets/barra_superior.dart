import 'package:flutter/material.dart';

class BarraSuperior extends StatelessWidget {
  const BarraSuperior({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1E293B),
      flexibleSpace: const FlexibleSpaceBar(
        title: Text(
          'Correção de Provas',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
