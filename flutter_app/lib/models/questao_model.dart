class Questao {
  final int id;
  final String tipo;
  final double valor;
  final String enunciado;
  final String? respostaCorreta;

  Questao({
    required this.id,
    required this.tipo,
    required this.valor,
    required this.enunciado,
    this.respostaCorreta,
  });

  factory Questao.fromJson(Map<String, dynamic> json) => Questao(
    id: json['id'],
    tipo: json['tipo'],
    valor: (json['valor'] as num).toDouble(),
    enunciado: json['enunciado'],
    respostaCorreta: json['respostaCorreta'],
  );
}