import 'package:flutter/material.dart';

class QuestaoMultiplaEscolha extends StatelessWidget {
  final int numeroQuestao;
  final String? respostaSelecionada;
  final String respostaCorreta;
  final Function(String?) onChanged;
  final bool isReadOnly;

  const QuestaoMultiplaEscolha({
    super.key,
    required this.numeroQuestao,
    required this.respostaSelecionada,
    required this.respostaCorreta,
    required this.onChanged,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    const opcoes = ['A', 'B', 'C', 'D', 'E'];
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$numeroQuestao',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...opcoes.map((opcao) {
            final isCorreta = opcao == respostaCorreta;
            final isSelecionada = opcao == respostaSelecionada;
            
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Radio<String>(
                  value: opcao,
                  groupValue: respostaSelecionada,
                  onChanged: isReadOnly ? null : onChanged,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (isCorreta) {
                      return Colors.green;
                    }
                    if (isSelecionada && !isCorreta) {
                      return Colors.red;
                    }
                    return null;
                  }),
                ),
              ),
            );
          }).toList(),
          SizedBox(
            width: 80,
            child: Icon(
              respostaSelecionada == respostaCorreta 
                ? Icons.check_circle 
                : Icons.cancel,
              color: respostaSelecionada == respostaCorreta 
                ? Colors.green 
                : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

