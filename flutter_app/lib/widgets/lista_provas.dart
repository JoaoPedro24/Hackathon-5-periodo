import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/prova_card.dart';

import '../models/prova_model.dart';

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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final prova = ProvaModel.fromJson(provas[index]);
          return ProvaCard(
            prova: prova,
            onVisualizar: () => onSelecionar(prova as Map<String, dynamic>),
          );
        },
        childCount: provas.length,
      ),
    );
  }
}