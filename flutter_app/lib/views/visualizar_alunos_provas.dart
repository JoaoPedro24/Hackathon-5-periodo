import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_helper.dart';
import '../models/alunos_status_model.dart';
import '../services/aluno_status_service.dart';
import '../widgets/modal_correcao.dart';

class VisualizarProvas extends StatefulWidget {
  final int provaId;

  const VisualizarProvas({super.key, required this.provaId});

  @override
  State<VisualizarProvas> createState() => _VisualizarProvaScreenState();
}

class _VisualizarProvaScreenState extends State<VisualizarProvas> {
  late Future<List<AlunoStatus>> _alunosStatusFuture;

  final AlunoStatusService _alunoStatusService = AlunoStatusService();

  @override
  void initState() {
    super.initState();
    _alunosStatusFuture = _loadAlunos();
  }

  Future<List<AlunoStatus>> _loadAlunos() async {
    final token = await AuthHelper.getToken();

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    return await _alunoStatusService.fetchAlunosStatus(
      widget.provaId,
      token,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status dos Alunos na Prova'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            tooltip: 'Sair',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Confirmar Logout'),
                    content: const Text('Você tem certeza que deseja sair?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Sair'),
                      ),
                    ],
                  );
                },
              );

              if (shouldLogout == true) {
                await AuthHelper.logout();
                if (mounted) {
                  // redireciona para a tela de login e remove o token
                  context.go('/login');
                }
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<AlunoStatus>>(
          future: _alunosStatusFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro: ${snapshot.error}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum aluno encontrado para esta prova.',
                  style: theme.textTheme.titleMedium,
                ),
              );
            } else {
              final alunos = snapshot.data!;
              return ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  final aluno = alunos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            aluno.nome,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColorDark,
                            ),
                          ),
                          if (aluno.matricula != null)
                            Text(
                              'Matrícula: ${aluno.matricula}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          const SizedBox(height: 4),
                          // Status
                          Text(
                            'Status: ${aluno.status}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),

                          // Exibe nota se já foi corrigido
                          if (aluno.nota != null) ...[
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  label: Text(
                                    'Nota: ${aluno.nota!.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: theme.primaryColor,
                                ),
                                if (aluno.acertos != null)
                                  Chip(
                                    label: Text(
                                      'Acertos: ${aluno.acertos}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],

                          // Botão Corrigir apenas se status for diferente de CORRIGIDO
                          if (aluno.status.toUpperCase() != 'CORRIGIDO')
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final atualizado =
                                      await showModalBottomSheet<bool>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder:
                                            (_) => ModalCorrecao(
                                              provaId: widget.provaId,
                                              alunoId: aluno.id,
                                            ),
                                      );

                                  if (atualizado == true) {
                                    setState(() {
                                      _alunosStatusFuture = _loadAlunos();
                                    });
                                  }
                                },
                                child: const Text('Corrigir'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
