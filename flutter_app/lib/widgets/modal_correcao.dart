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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                          respostas[questao.questaoId] ?? questao.respostaAluno;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questao.enunciado,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...questao.alternativas.map(
                                (alt) => RadioListTile<String>(
                                  title: Text('Alternativa $alt'),
                                  value: alt,
                                  groupValue: selecionada,
                                  onChanged: (val) {
                                    setState(() {
                                      respostas[questao.questaoId] = val;
                                    });
                                  },
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
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questao.enunciado,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: controller,
                                maxLines: null,
                                onChanged: (val) {
                                  respostas[questao.questaoId] = val;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
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
              ElevatedButton(
                onPressed: () async {
                  final viewModel = CorrecaoViewModel();

                  // Monta a lista de correções com valor padrão (ajuste conforme necessário)
                  final correcoes =
                      respostas.entries.map((entry) {
                        return RespostaCorrecao(
                          questaoId: entry.key,
                          resposta: entry.value.toString(),
                          valor:
                              5.0, // Aqui você pode abrir um campo para nota por questão se quiser
                        );
                      }).toList();

                  final req = CorrecaoRequest(
                    alunoId: widget.alunoId,
                    provaId: widget.provaId,
                    respostas: correcoes,
                  );

                  await viewModel.corrigirProva(req);

                  if (viewModel.sucesso) {
                    Navigator.pop(
                      context,
                      true,
                    ); // Retorna true para recarregar lista
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          viewModel.errorMessage ?? 'Erro ao corrigir prova',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Salvar Correção'),
              ),
            ],
          );
        },
      ),
    );
  }
}
