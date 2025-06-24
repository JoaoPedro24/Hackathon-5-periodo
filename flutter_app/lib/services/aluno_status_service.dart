
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/alunos_status_model.dart';

class AlunoStatusService {
  AlunoStatusService();
  Future<List<AlunoStatus>> fetchAlunosStatus(int provaId, String token) async {
    final url = 'http://localhost:8080/api/provas/$provaId/alunos-status';

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
