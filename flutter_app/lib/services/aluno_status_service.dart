// lib/services/aluno_status_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/alunos_status_model.dart';

class AlunoStatusService {
  // Construtor opcional, caso precise de dependências (ex: Dio, configurações de base URL)
  AlunoStatusService();

  // Método para buscar o status dos alunos da API
  // Ele retorna diretamente a lista de AlunoStatus ou lança uma exceção
  Future<List<AlunoStatus>> fetchAlunosStatus(int provaId, String token) async {
    // URL da API, ajustando para o localhost do emulador Android se necessário
    final url =
        'http://localhost:8080/api/provas/$provaId/alunos-status'; // Para emulador Android

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Código da resposta: ${response.statusCode}');
      print('Body da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AlunoStatus.fromJson(json)).toList();
      } else {
        throw Exception(
          'Falha ao carregar status dos alunos: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erro no AlunoStatusService ao buscar alunos: $e');
      throw Exception('Erro de conexão ou ao processar dados: $e');
    }
  }
}
