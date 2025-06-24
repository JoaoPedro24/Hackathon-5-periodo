import 'package:flutter/material.dart';
import '../services/login_auth_service.dart';
import '../models/usuario_model.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginAuthService _authService = LoginAuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<Usuario?> fazerLogin(String login, String senha) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuario = await _authService.login(login, senha);
      if (usuario == null) {
        _errorMessage = 'Login ou senha inválidos';
      }
      return usuario;
    } catch (e) {
      _errorMessage = 'Erro ao conectar com o servidor';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
