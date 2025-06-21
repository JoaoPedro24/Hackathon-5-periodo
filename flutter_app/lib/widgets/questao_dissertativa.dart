import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuestaoDissertativa extends StatelessWidget {
  final int numeroQuestao;
  final double valorMaximo;
  final double? valorAtribuido;
  final Function(double?) onChanged;
  final bool isReadOnly;

  const QuestaoDissertativa({
    super.key,
    required this.numeroQuestao,
    required this.valorMaximo,
    required this.valorAtribuido,
    required this.onChanged,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: valorAtribuido?.toString() ?? '',
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              'Questão $numeroQuestao',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valor máximo: ${valorMaximo.toString()}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: controller,
                  enabled: !isReadOnly,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    hintText: '0.0',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    errorText: _getErrorText(controller.text),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      onChanged(null);
                      return;
                    }
                    
                    final doubleValue = double.tryParse(value);
                    if (doubleValue != null && doubleValue <= valorMaximo) {
                      onChanged(doubleValue);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: valorAtribuido != null
              ? Icon(
                  Icons.assignment_turned_in,
                  color: Colors.green,
                )
              : Icon(
                  Icons.assignment_late,
                  color: Colors.orange,
                ),
          ),
        ],
      ),
    );
  }

  String? _getErrorText(String value) {
    if (value.isEmpty) return null;
    
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'Valor inválido';
    }
    
    if (doubleValue > valorMaximo) {
      return 'Valor não pode ser maior que $valorMaximo';
    }
    
    if (doubleValue < 0) {
      return 'Valor não pode ser negativo';
    }
    
    return null;
  }
}

