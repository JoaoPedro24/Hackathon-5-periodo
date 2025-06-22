// models/prova_model.dart
class Questao {
  final int id;
  final String tipo;
  final double valor;
  final String enunciado;
  final String respostaCorreta;

  Questao({
    required this.id,
    required this.tipo,
    required this.valor,
    required this.enunciado,
    required this.respostaCorreta,
  });

  factory Questao.fromJson(Map<String, dynamic> json) => Questao(
    id: json['id'],
    tipo: json['tipo'],
    valor: (json['valor'] as num).toDouble(),
    enunciado: json['enunciado'],
    respostaCorreta: json['respostaCorreta'],
  );
}

class ProvaModel {
  final int id;
  final String nome;
  final double valorTotal;
  final String disciplina;
  final String turma;
  final List<Questao> questoes;

  ProvaModel({
    required this.id,
    required this.nome,
    required this.valorTotal,
    required this.disciplina,
    required this.turma,
    required this.questoes,
  });

  factory ProvaModel.fromJson(Map<String, dynamic> json) => ProvaModel(
    id: json['id'],
    nome: json['nome'],
    valorTotal: (json['valorTotal'] as num).toDouble(),
    disciplina: json['disciplina'],
    turma: json['turma'],
    questoes: List<Questao>.from(json['questoes'].map((x) => Questao.fromJson(x))),
  );
}

