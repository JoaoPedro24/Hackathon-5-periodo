import 'package:flutter/material.dart';

class CorrecaoAluno extends StatefulWidget {
  final String nomeProva;
  final List<String> alunos;

  const CorrecaoAluno({
    super.key,
    required this.nomeProva,
    required this.alunos,
  });

  @override
  State<CorrecaoAluno> createState() => _CorrecaoAlunoState();
}

class _CorrecaoAlunoState extends State<CorrecaoAluno> {
  late String _alunoSelecionado;
  final Map<int, String> _respostasObjetivas = {};
  final Map<int, double> _respostasDissertativas = {};

  @override
  void initState() {
    super.initState();
    _alunoSelecionado = widget.alunos.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                widget.nomeProva,
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: DropdownButtonFormField<String>(
                value: _alunoSelecionado,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                items:
                    widget.alunos
                        .map(
                          (aluno) => DropdownMenuItem(
                            value: aluno,
                            child: Text(aluno),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _alunoSelecionado = value);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Questões",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            _buildTabelaQuestoes(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Salvar lógica
                  },
                  child: const Text("Salvar Resposta"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabelaQuestoes() {
    final colunas = ['Nº', 'A', 'B', 'C', 'D', 'E'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: colunas.map((c) => DataColumn(label: Text(c))).toList(),
        rows: List.generate(5, (i) {
          if (i < 3) {
            // Objetiva
            return DataRow(
              cells: [
                DataCell(Text('${i + 1}')),
                ...['A', 'B', 'C', 'D', 'E'].map(
                  (letra) => DataCell(
                    IconButton(
                      icon: Icon(
                        _respostasObjetivas[i] == letra
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() => _respostasObjetivas[i] = letra);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Dissertativa
            return DataRow(
              cells: [
                DataCell(Text('${i + 1}')),
                DataCell(
                  Text('Questão\nDissertativa'),
                  showEditIcon: false,
                  placeholder: true,
                ),
                DataCell(Text('Digite o valor:')),
                DataCell(
                  SizedBox(
                    width: 40,
                    child: TextFormField(
                      initialValue:
                          _respostasDissertativas[i]?.toString() ?? '0',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final nota = double.tryParse(value) ?? 0;
                        setState(() => _respostasDissertativas[i] = nota);
                      },
                    ),
                  ),
                ),
                const DataCell(SizedBox()), // Espaços vazios pra completar
                const DataCell(SizedBox()),
              ],
            );
          }
        }),
      ),
    );
  }
}
