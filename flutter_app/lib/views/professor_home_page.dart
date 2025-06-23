import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../viewmodel/prova_viewmodel.dart';
import '../../widgets/prova_card.dart';

class ProfessorHomePage extends StatefulWidget {
  const ProfessorHomePage({super.key});

  @override
  State<ProfessorHomePage> createState() => _ProfessorHomePageState();
}

class _ProfessorHomePageState extends State<ProfessorHomePage> {
  String? nomeUsuario;

  @override
  void initState() {
    super.initState();
    carregarNomeUsuario();
  }

  Future<void> carregarNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeUsuario = prefs.getString('usuario_nome') ?? 'Professor';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProvaViewModel()..carregarProvas(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Área do Professor'),
        ),
        body: Consumer<ProvaViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.provas.isEmpty) {
              return const Center(
                child: Text('Nenhuma prova cadastrada.'),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo, ${nomeUsuario ?? 'Professor'}!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.provas.length,
                      itemBuilder: (context, index) {
                        final prova = viewModel.provas[index];
                        return ProvaCard(prova: prova);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
