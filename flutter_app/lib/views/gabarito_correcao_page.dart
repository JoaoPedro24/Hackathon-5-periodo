import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/questao_multipla_escolha.dart';
import 'package:flutter_app/widgets/questao_dissertativa.dart';

class GabaritoCorrecaoPage extends StatefulWidget {
  final Map<String, dynamic> disciplina;
  final Map<String, dynamic> turma;
  final Map<String, dynamic> aluno;

  const GabaritoCorrecaoPage({
    super.key,
    required this.disciplina,
    required this.turma,
    required this.aluno,
  });

  @override
  State<GabaritoCorrecaoPage> createState() => _GabaritoCorrecaoPageState();
}

class _GabaritoCorrecaoPageState extends State<GabaritoCorrecaoPage> {
  List<Map<String, dynamic>> questoes = [];
  Map<int, String?> respostasMultiplas = {};
  Map<int, double?> respostasDissertativas = {};
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadGabarito();
  }

  Future<void> _loadGabarito() async {
    setState(() {
      isLoading = true;
    });
    // Simulação de carregamento do gabarito do backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      questoes = [
        {"questao_numero": 1, "tipo": "Múltipla Escolha", "valor": 2.0, "resposta_correta": "A"},
        {"questao_numero": 2, "tipo": "Dissertativa", "valor": 3.0},
        {"questao_numero": 3, "tipo": "Dissertativa", "valor": 1.0},
        {"questao_numero": 4, "tipo": "Múltipla Escolha", "valor": 2.0, "resposta_correta": "C"},
        {"questao_numero": 5, "tipo": "Dissertativa", "valor": 4.0},
        {"questao_numero": 6, "tipo": "Múltipla Escolha", "valor": 1.5, "resposta_correta": "B"},
        {"questao_numero": 7, "tipo": "Múltipla Escolha", "valor": 2.5, "resposta_correta": "D"},
        {"questao_numero": 8, "tipo": "Dissertativa", "valor": 3.0},
        {"questao_numero": 9, "tipo": "Múltipla Escolha", "valor": 1.0, "resposta_correta": "E"},
        {"questao_numero": 10, "tipo": "Dissertativa", "valor": 2.0},
      ];
      isLoading = false;
    });
  }

  void _onRespostaMultiplaChanged(int questaoNumero, String? resposta) {
    setState(() {
      respostasMultiplas[questaoNumero] = resposta;
    });
  }

  void _onRespostaDissertativaChanged(int questaoNumero, double? valor) {
    setState(() {
      respostasDissertativas[questaoNumero] = valor;
    });
  }

  double _calcularNotaTotal() {
    double total = 0.0;
    for (var questao in questoes) {
      final numero = questao['questao_numero'] as int;
      final tipo = questao['tipo'] as String;
      final valorMaximo = (questao['valor'] as num).toDouble();
      if (tipo == 'Múltipla Escolha') {
        final respostaSelecionada = respostasMultiplas[numero];
        final respostaCorreta = questao['resposta_correta'] as String;
        if (respostaSelecionada == respostaCorreta) {
          total += valorMaximo;
        }
      } else if (tipo == 'Dissertativa') {
        final valorAtribuido = respostasDissertativas[numero];
        if (valorAtribuido != null) {
          total += valorAtribuido;
        }
      }
    }
    return total;
  }

  bool _isGabaritoCompleto() {
    for (var questao in questoes) {
      final numero = questao['questao_numero'] as int;
      final tipo = questao['tipo'] as String;
      if (tipo == 'Múltipla Escolha') {
        if (respostasMultiplas[numero] == null) return false;
      } else if (tipo == 'Dissertativa') {
        if (respostasDissertativas[numero] == null) return false;
      }
    }
    return true;
  }

  Future<void> _salvarGabarito() async {
    if (!_isGabaritoCompleto()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complete todas as questões antes de salvar'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }
    setState(() {
      isSaving = true;
    });
    // Simulação de salvamento no backend
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isSaving = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gabarito salvo com sucesso!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Correção: ${widget.aluno['nome']}'),
        backgroundColor: theme.primaryColor,
        elevation: 2,
        actions: [
          if (!isLoading)
            TextButton(
              onPressed: isSaving ? null : _salvarGabarito,
              child: Text(
                'SALVAR',
                style: textTheme.labelLarge?.copyWith(
                  color: _isGabaritoCompleto()
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onPrimary.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(theme.primaryColor),
          ),
        )
            : Column(
          children: [
            // Informações do aluno em Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aluno: ${widget.aluno['nome']}',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Código: ${widget.aluno['codigo']}', style: textTheme.bodyMedium),
                      Text('Disciplina: ${widget.disciplina['nome']}', style: textTheme.bodyMedium),
                      Text('Turma: ${widget.turma['nome']}', style: textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Nota Atual: ${_calcularNotaTotal().toStringAsFixed(1)}',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Cabeçalho da lista de questões
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: theme.primaryColor,
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      'Questão',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Resposta / Valor',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Status',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Lista de questões
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: questoes.length,
                itemBuilder: (context, index) {
                  final questao = questoes[index];
                  final numero = questao['questao_numero'] as int;
                  final tipo = questao['tipo'] as String;
                  final valor = (questao['valor'] as num).toDouble();
                  if (tipo == 'Múltipla Escolha') {
                    final respostaCorreta = questao['resposta_correta'] as String;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: QuestaoMultiplaEscolha(
                        numeroQuestao: numero,
                        respostaSelecionada: respostasMultiplas[numero],
                        respostaCorreta: respostaCorreta,
                        onChanged: (resposta) => _onRespostaMultiplaChanged(numero, resposta),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: QuestaoDissertativa(
                        numeroQuestao: numero,
                        valorMaximo: valor,
                        valorAtribuido: respostasDissertativas[numero],
                        onChanged: (valor) => _onRespostaDissertativaChanged(numero, valor),
                      ),
                    );
                  }
                },
              ),
            ),
            // Botão de salvar fixo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving || !_isGabaritoCompleto() ? null : _salvarGabarito,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSaving
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Salvando...', style: textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary)),
                    ],
                  )
                      : Text(
                    'Salvar Gabarito (${_calcularNotaTotal().toStringAsFixed(1)} pts)',
                    style: textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
