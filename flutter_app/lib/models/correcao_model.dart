
class RespostaCorrecao {
  final int questaoId;
  final String resposta;
  final double valor;

  RespostaCorrecao({
    required this.questaoId,
    required this.resposta,
    required this.valor,
  });

  Map<String, dynamic> toJson() => {
    'questaoId': questaoId,
    'resposta': resposta,
    'valor': valor,
  };
}

class CorrecaoRequest {
  final int alunoId;
  final int provaId;
  final List<RespostaCorrecao> respostas;

  CorrecaoRequest({
    required this.alunoId,
    required this.provaId,
    required this.respostas,
  });

  Map<String, dynamic> toJson() => {
    'alunoId': alunoId,
    'provaId': provaId,
    'respostas': respostas.map((r) => r.toJson()).toList(),
  };
}
