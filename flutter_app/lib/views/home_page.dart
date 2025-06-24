// lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_animated/auto_animated.dart'; // Importe o auto_animated
import '../../viewmodel/prova_viewmodel.dart';
import '../../widgets/prova_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _ProfessorHomePageState();
}

class _ProfessorHomePageState extends State<HomePage> {
  String? nomeUsuario;

  @override
  void initState() {
    super.initState();
    carregarNomeUsuario();
    // Use addPostFrameCallback para garantir que o contexto esteja totalmente disponível
    // e para evitar chamadas de Provider no meio do build tree inicial,
    // embora Future.microtask também seja uma boa opção para iniciar async ops.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvaViewModel>(context, listen: false).carregarProvas();
    });
  }

  Future<void> carregarNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    // *** CORREÇÃO AQUI: Verifique se o widget ainda está montado antes de chamar setState ***
    // Isso previne o erro "Trying to render a disposed EngineFlutterView."
    if (!mounted) return;
    setState(() {
      nomeUsuario = prefs.getString('usuario_nome') ?? 'Professor';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Área do Professor')),
      body: Consumer<ProvaViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.provas.isEmpty) {
            return const Center(child: Text('Nenhuma prova cadastrada.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Bem-vindo, ${nomeUsuario ?? 'Professor'}!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Removi o SizedBox duplicado aqui, se for intencional pode voltar
                // const SizedBox(height: 20),
                Expanded(
                  child: LiveList(
                    showItemInterval: const Duration(milliseconds: 150),
                    showItemDuration: const Duration(milliseconds: 300),
                    reAnimateOnVisibility: true,
                    itemCount: viewModel.provas.length,
                    itemBuilder: (context, index, animation) {
                      final prova = viewModel.provas[index];
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(animation),
                          child: ProvaCard(prova: prova),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
