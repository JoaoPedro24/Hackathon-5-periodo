import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_helper.dart';
import '../models/questao_com_reposta_model.dart';

class QuestaoService {
  // URL fixa para buscar questões da prova (troque localhost para 10.0.2.2 se for Android emulator)
  Future<List<QuestaoComResposta>> fetchQuestoes(int provaId) async {
    final urlQ = Uri.parse(
      'http://localhost:8080/api/provas/$provaId/questoes',
    );
    final token = await AuthHelper.getToken();
    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }
    print('URL para buscar questões: $urlQ');
    print('Token usado: $token');

    final response = await http.get(
      urlQ,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Código da resposta: ${response.statusCode}');
    print('Body da resposta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      return jsonList.map((json) {
        final questao = QuestaoComResposta.fromJson(json);

        // Mock temporário para alternativas e resposta do aluno
        if (questao.tipo == 'ALTERNATIVA' && questao.alternativas.isEmpty) {
          questao.alternativas = ['A', 'B', 'C', 'D', 'E'];
        }

        if (questao.respostaAluno == null) {
          questao.respostaAluno = questao.tipo == 'ALTERNATIVA' ? '' : '';
        }

        return questao;
      }).toList();
    } else {
      print(
        'Erro ao carregar questões: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Falha ao carregar questões: ${response.statusCode}');
    }
  }
}
