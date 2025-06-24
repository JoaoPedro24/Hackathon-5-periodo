import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_helper.dart';
import '../models/correcao_model.dart';

class CorrecaoService {
  final String _urlCorrecao = 'http://localhost:8080/api/correcao/aluno';

  Future<void> enviarCorrecao(CorrecaoRequest correcao) async {
    final token = await AuthHelper.getToken();
    final response = await http.post(
      Uri.parse(_urlCorrecao),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(correcao.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao enviar correção: ${response.statusCode} - ${response.body}');
    }
  }
}
