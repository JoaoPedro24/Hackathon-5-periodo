// lib/models/aluno_status_model.dart
class AlunoStatus {
  final int id;
  final String nome;
  final String status; // Ex: 'Entregue', 'Não Entregue', 'Corrigido'
  final String? matricula;
  final double? nota;
  final int? acertos;

  AlunoStatus({
    required this.id,
    required this.nome,
    required this.status,
    this.matricula,
    this.nota,
    this.acertos,
  });

  factory AlunoStatus.fromJson(Map<String, dynamic> json) {
    return AlunoStatus(
      id: json['alunoId'],
      nome: json['nomeAluno'],
      status: json['status'],
      matricula: json['matricula'],
      nota: (json['nota'] as num?)?.toDouble(),
      acertos: json['acertos'],
    );
  }
}
