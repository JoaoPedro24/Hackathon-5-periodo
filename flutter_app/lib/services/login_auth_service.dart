import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_helper.dart';
import '../models/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAuthService {
  Future<Usuario?> login(String login, String senha) async {

    final url = Uri.parse('http://localhost:8080/auth/login');
    print('URL: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'login': login, 'senha': senha}),
      );

      print('Código da resposta: ${response.statusCode}');
      print('Body da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final usuario = Usuario.fromJson(data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', usuario.token);
        await prefs.setString('usuario_nome', usuario.nome);
        await prefs.setString('usuario_role', usuario.role);

        await AuthHelper.saveToken(usuario.token);

        return usuario;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao conectar: $e');
      return null;
    }
  }
}