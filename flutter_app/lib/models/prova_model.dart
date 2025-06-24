
class ProvaModel {
  final int id;
  final String nome;
  final double valorTotal;
  final String disciplina;
  final String turma;
  // final List<Questao> questoes;

  ProvaModel({
    required this.id,
    required this.nome,
    required this.valorTotal,
    required this.disciplina,
    required this.turma,
    // required this.questoes,
  });

  factory ProvaModel.fromJson(Map<String, dynamic> json) => ProvaModel(
    id: json['id'],
    nome: json['nome'],
    valorTotal: (json['valorTotal'] as num).toDouble(),
    disciplina: json['disciplina'],
    turma: json['turma'],
    // questoes: List<Questao>.from(json['questoes'].map((x) => Questao.fromJson(x))),
  );
}

