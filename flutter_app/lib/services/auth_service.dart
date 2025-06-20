import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';

class AuthService {
  final String _baseUrl = 'http://localhost:8080';

  Future<Usuario?> login(String login, String senha) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'login': login, 'senha': senha}),
    );

    print('Código da resposta: ${response.statusCode}');
    print('Body da resposta: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromJson(data);
    } else {
      return null;
    }
  }
}
