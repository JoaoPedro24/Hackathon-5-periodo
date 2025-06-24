import 'package:flutter/material.dart';
import '../models/prova_model.dart';
import '../services/prova_service.dart';

class ProvaViewModel extends ChangeNotifier {
  final ProvaService _service = ProvaService();
  List<ProvaModel> _provas = [];
  bool _isLoading = false;

  List<ProvaModel> get provas => _provas;

  bool get isLoading => _isLoading;

  Future<void> carregarProvas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _provas =
      await _service.fetchProvasProfessor();
    } catch (e) {
      print('Erro ao carregar provas: $e');
      _provas = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
