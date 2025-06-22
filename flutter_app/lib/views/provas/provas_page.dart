// views/provas/provas_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/prova_viewmodel.dart';
import '../../widgets/prova_card.dart';

class ProvasPage extends StatelessWidget {
  const ProvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProvaViewModel()..carregarProvas(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Gerenciar Provas')),
        body: Consumer<ProvaViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.provas.isEmpty) {
              return const Center(child: Text('Nenhuma prova cadastrada.'));
            }

            return ListView.builder(
              itemCount: viewModel.provas.length,
              itemBuilder: (context, index) {
                final prova = viewModel.provas[index];
                return ProvaCard(prova: prova);
              },
            );
          },
        ),
      ),
    );
  }
}
