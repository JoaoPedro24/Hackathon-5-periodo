  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import '../models/usuario_model.dart';

  class AuthService {
    Future<Usuario?> login(String login, String senha) async {
      final url = Uri.parse('http://localhost:8080/auth/login');
      print('URL: $url');

  // Certifique-se que é /auth/login

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json', // Adicione isso
          },
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
      } catch (e) {
        print('Erro ao conectar: $e');
        return null;
      }
    }
  }
