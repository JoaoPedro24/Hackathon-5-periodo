// lib/models/aluno_status_model.dart
class AlunoStatus {
  final int id;
  final String nome;
  final String status; // Ex: 'Entregue', 'Não Entregue', 'Corrigido'
  final String? matricula;
  final double? nota;

  AlunoStatus({
    required this.id,
    required this.nome,
    required this.status,
    this.matricula,
    this.nota,
  });

  factory AlunoStatus.fromJson(Map<String, dynamic> json) {
    return AlunoStatus(
      // Mapeia 'alunoId' do JSON para 'id' do modelo
      id: json['alunoId'],
      // Mapeia 'nomeAluno' do JSON para 'nome' do modelo
      nome: json['nomeAluno'],
      // 'status' permanece o mesmo
      status: json['status'],
      // 'nota' ainda é opcional e pode ser nulo se não vier no JSON
      nota: (json['nota'] as num?)?.toDouble(),
      matricula: json['matricula'],
    );
  }
}
