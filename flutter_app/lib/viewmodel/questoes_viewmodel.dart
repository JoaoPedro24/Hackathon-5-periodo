import 'package:flutter/material.dart';
import '../models/questao_com_reposta_model.dart';
import '../services/questao_service.dart';

class QuestaoViewModel extends ChangeNotifier {
  final QuestaoService _questaoService = QuestaoService();

  List<QuestaoComResposta> questoes = [];
  bool isLoading = false;
  String? error;

  Future<void> carregarQuestoes(int provaId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      questoes = await _questaoService.fetchQuestoes(provaId);
    } catch (e) {
      error = e.toString();
      questoes = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
