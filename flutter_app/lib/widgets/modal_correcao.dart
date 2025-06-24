import 'package:flutter/material.dart';
import '../models/correcao_model.dart';
import '../models/questao_com_reposta_model.dart';
import '../services/questao_service.dart';
import '../viewmodel/correcao_viewmodel.dart';

class ModalCorrecao extends StatefulWidget {
  final int provaId;
  final int alunoId;

  const ModalCorrecao({Key? key, required this.provaId, required this.alunoId})
    : super(key: key);

  @override
  _ModalCorrecaoState createState() => _ModalCorrecaoState();
}

class _ModalCorrecaoState extends State<ModalCorrecao> {
  final QuestaoService _questaoService = QuestaoService();

  late Future<List<QuestaoComResposta>> _questoesFuture;
  Map<int, dynamic> respostas = {};

  @override
  void initState() {
    super.initState();
    _questoesFuture = _questaoService.fetchQuestoes(widget.provaId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: FutureBuilder<List<QuestaoComResposta>>(
          future: _questoesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma questão encontrada.'));
            }
            final questoes = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: questoes.length,
                    itemBuilder: (context, index) {
                      final questao = questoes[index];

                      if (questao.tipo == 'ALTERNATIVA') {
                        final selecionada =
                            respostas[questao.questaoId] ??
                            questao.respostaAluno;

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${questao.enunciado}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColorDark,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...questao.alternativas.map(
                                  (alt) => RadioListTile<String>(
                                    title: Text(alt),
                                    value: alt,
                                    groupValue: selecionada,
                                    onChanged: (val) {
                                      setState(() {
                                        respostas[questao.questaoId] = val;
                                      });
                                    },
                                    activeColor: theme.primaryColor,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        final controller = TextEditingController(
                          text:
                              respostas[questao.questaoId] ??
                              questao.respostaAluno ??
                              '',
                        );

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' ${questao.enunciado}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColorDark,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: controller,
                                  maxLines: null,
                                  onChanged: (val) {
                                    respostas[questao.questaoId] = val;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Digite a resposta',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final questoes = await _questoesFuture;
                        bool hasErro = false;
                        String? errorMessage;

                        for (var questao in questoes) {
                          final resposta = respostas[questao.questaoId];
                          if (questao.tipo == 'ALTERNATIVA') {
                            if (resposta == null ||
                                resposta.toString().isEmpty) {
                              hasErro = true;
                              errorMessage = 'Selecione todas as alternativas.';
                              break;
                            }
                          } else {
                            if (resposta == null ||
                                resposta.toString().trim().isEmpty) {
                              hasErro = true;
                              errorMessage =
                                  'Responda todas as questões dissertativas.';
                              break;
                            }
                          }
                        }

                        if (hasErro) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage!)),
                          );
                          return;
                        }

                        final viewModel = CorrecaoViewModel();
                        final correcoes =
                            respostas.entries.map((entry) {
                              return RespostaCorrecao(
                                questaoId: entry.key,
                                resposta: entry.value.toString(),
                                valor: 5.0,
                              );
                            }).toList();

                        final req = CorrecaoRequest(
                          alunoId: widget.alunoId,
                          provaId: widget.provaId,
                          respostas: correcoes,
                        );

                        await viewModel.corrigirProva(req);

                        if (viewModel.sucesso) {
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                viewModel.errorMessage ??
                                    'Erro ao corrigir prova',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Salvar Correção'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}
