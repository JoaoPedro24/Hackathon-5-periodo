// services/prova_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_helper.dart';
import '../models/prova_model.dart';

class ProvaService {
  // Ajuste se necessário

  Future<List<ProvaModel>> fetchProvas() async {

    final tokenA = await AuthHelper.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('Token salvo: $token');
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/provas'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },

    );
    print('🔐 Token sendo usado para buscar provas: $token');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => ProvaModel.fromJson(e)).toList();
    } else {
      print('Erro: ${response.statusCode} - ${response.body}');
      throw Exception('Erro ao buscar provas');
    }
  }
}
