class QuestaoComResposta {
  final int questaoId;
  final String enunciado;
  final String tipo;
  final double valor;

  List<String> alternativas;
  String? respostaAluno;

  QuestaoComResposta({
    required this.questaoId,
    required this.enunciado,
    required this.tipo,
    required this.valor,
    this.alternativas = const [],
    this.respostaAluno,
  });

  factory QuestaoComResposta.fromJson(Map<String, dynamic> json) {
    return QuestaoComResposta(
      questaoId: json['questaoId'],
      enunciado: json['enunciado'],
      tipo: json['tipo'],
      valor: (json['valor'] as num).toDouble(),
      alternativas: json['alternativas'] != null
          ? List<String>.from(json['alternativas'])
          : [],
      respostaAluno: json['respostaAluno'],
    );
  }
}
