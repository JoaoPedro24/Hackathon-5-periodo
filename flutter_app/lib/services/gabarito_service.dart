import 'dart:convert';
import 'package:http/http.dart' as http;

class GabaritoService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Buscar disciplinas do professor
  static Future<List<Map<String, dynamic>>> getDisciplinasProfessor(int professorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/professor/$professorId/disciplinas'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao carregar disciplinas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar turmas de uma disciplina
  static Future<List<Map<String, dynamic>>> getTurmasDisciplina(int disciplinaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/disciplina/$disciplinaId/turmas'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao carregar turmas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar alunos de uma turma
  static Future<List<Map<String, dynamic>>> getAlunosTurma(int turmaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/turma/$turmaId/alunos'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao carregar alunos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar gabarito de uma prova
  static Future<List<Map<String, dynamic>>> getGabaritoProva(int provaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/prova/$provaId/gabarito'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao carregar gabarito: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Verificar se aluno já foi corrigido
  static Future<bool> isAlunoCorrigido(int alunoId, int provaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/aluno/$alunoId/prova/$provaId/corrigido'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['corrigido'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Salvar correção do gabarito
  static Future<bool> salvarCorrecaoGabarito({
    required int alunoId,
    required int provaId,
    required Map<int, String?> respostasMultiplas,
    required Map<int, double?> respostasDissertativas,
    required double notaTotal,
  }) async {
    try {
      final Map<String, dynamic> correcaoData = {
        'alunoId': alunoId,
        'provaId': provaId,
        'respostasMultiplas': respostasMultiplas.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
        'respostasDissertativas': respostasDissertativas.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
        'notaTotal': notaTotal,
        'dataCorrecao': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/correcao/salvar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(correcaoData),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Buscar correção existente
  static Future<Map<String, dynamic>?> getCorrecaoExistente(int alunoId, int provaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/aluno/$alunoId/prova/$provaId/correcao'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Validar valor de questão dissertativa
  static bool validarValorDissertativa(double? valor, double valorMaximo) {
    if (valor == null) return false;
    return valor >= 0 && valor <= valorMaximo;
  }

  // Calcular nota total
  static double calcularNotaTotal({
    required List<Map<String, dynamic>> questoes,
    required Map<int, String?> respostasMultiplas,
    required Map<int, double?> respostasDissertativas,
  }) {
    double total = 0.0;
    
    for (var questao in questoes) {
      final numero = questao['questao_numero'] as int;
      final tipo = questao['tipo'] as String;
      final valorMaximo = (questao['valor'] as num).toDouble();
      
      if (tipo == 'Múltipla Escolha') {
        final respostaSelecionada = respostasMultiplas[numero];
        final respostaCorreta = questao['resposta_correta'] as String?;
        
        if (respostaSelecionada != null && 
            respostaCorreta != null && 
            respostaSelecionada == respostaCorreta) {
          total += valorMaximo;
        }
      } else if (tipo == 'Dissertativa') {
        final valorAtribuido = respostasDissertativas[numero];
        if (valorAtribuido != null && validarValorDissertativa(valorAtribuido, valorMaximo)) {
          total += valorAtribuido;
        }
      }
    }
    
    return total;
  }
}

