import 'package:flutter/material.dart';

class AlunoAutocomplete extends StatelessWidget {
  final List<Map<String, dynamic>> alunos;
  final Function(Map<String, dynamic>?) onSelected;
  final TextEditingController controller;

  const AlunoAutocomplete({
    super.key,
    required this.alunos,
    required this.onSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buscar Aluno por Código:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Autocomplete<Map<String, dynamic>>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<Map<String, dynamic>>.empty();
              }
              return alunos.where((aluno) {
                final codigo = aluno['codigo']?.toString().toLowerCase() ?? '';
                final nome = aluno['nome']?.toString().toLowerCase() ?? '';
                final searchText = textEditingValue.text.toLowerCase();
                return codigo.contains(searchText) || nome.contains(searchText);
              });
            },
            displayStringForOption: (Map<String, dynamic> option) {
              return '${option['codigo']} - ${option['nome']}';
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite o código ou nome do aluno',
                  prefixIcon: Icon(Icons.search),
                ),
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = options.elementAt(index);
                        final jaCorrigido = option['jaCorrigido'] ?? false;
                        
                        return ListTile(
                          enabled: !jaCorrigido,
                          title: Text(
                            '${option['codigo']} - ${option['nome']}',
                            style: TextStyle(
                              color: jaCorrigido ? Colors.grey : null,
                            ),
                          ),
                          subtitle: jaCorrigido 
                            ? const Text(
                                'Já corrigido',
                                style: TextStyle(color: Colors.red),
                              )
                            : null,
                          trailing: jaCorrigido 
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                          onTap: jaCorrigido 
                            ? null 
                            : () {
                                onSelected(option);
                              },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}

