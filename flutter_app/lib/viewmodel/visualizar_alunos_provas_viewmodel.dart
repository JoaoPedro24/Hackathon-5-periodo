
import 'package:flutter/material.dart';
import '../models/alunos_status_model.dart';
import '../services/aluno_status_service.dart';

class VisualizarAlunosProvasViewmodel extends ChangeNotifier {
  final AlunoStatusService _alunoStatusService;
  String? _token;

  VisualizarAlunosProvasViewmodel(this._alunoStatusService);

  List<AlunoStatus> _alunos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AlunoStatus> get alunos => _alunos;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  void setToken(String token) {
    _token = token;
  }

  Future<void> fetchAlunosStatus(int provaId) async {
    if (_token == null) {
      _errorMessage = 'Token de autenticação não definido.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _alunos = await _alunoStatusService.fetchAlunosStatus(provaId, _token!);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _alunos = [];
      print('Erro no VisualizarProvasViewModel ao buscar alunos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
