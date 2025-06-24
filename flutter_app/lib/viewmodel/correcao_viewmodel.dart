import 'package:flutter/material.dart';
import '../models/correcao_model.dart';
import '../services/correcao_service.dart';

class CorrecaoViewModel extends ChangeNotifier {
  final CorrecaoService _service = CorrecaoService();

  bool isLoading = false;
  String? errorMessage;
  bool sucesso = false;

  Future<void> corrigirProva(CorrecaoRequest correcao) async {
    isLoading = true;
    errorMessage = null;
    sucesso = false;
    notifyListeners();

    try {
      await _service.enviarCorrecao(correcao);
      sucesso = true;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
