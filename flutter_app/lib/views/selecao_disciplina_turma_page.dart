import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/disciplina_selector.dart';
import 'package:flutter_app/widgets/turma_selector.dart';
import 'package:flutter_app/views/selecao_aluno_correcao_page.dart';

class SelecaoDisciplinaTurmaPage extends StatefulWidget {
  const SelecaoDisciplinaTurmaPage({super.key});

  @override
  State<SelecaoDisciplinaTurmaPage> createState() => _SelecaoDisciplinaTurmaPageState();
}

class _SelecaoDisciplinaTurmaPageState extends State<SelecaoDisciplinaTurmaPage> {
  Map<String, dynamic>? selectedDisciplina;
  Map<String, dynamic>? selectedTurma;
  List<Map<String, dynamic>> disciplinas = [];
  List<Map<String, dynamic>> turmas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDisciplinas();
  }

  Future<void> _loadDisciplinas() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      disciplinas = [
        {'id': 1, 'nome': 'Matemática'},
        {'id': 2, 'nome': 'Português'},
        {'id': 3, 'nome': 'História'},
        {'id': 4, 'nome': 'Geografia'},
        {'id': 5, 'nome': 'Ciências'},
      ];
      isLoading = false;
    });
  }

  Future<void> _loadTurmas(int disciplinaId) async {
    setState(() {
      isLoading = true;
      selectedTurma = null;
      turmas = [];
    });

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      turmas = [
        {'id': 1, 'nome': 'Turma A', 'disciplinaId': disciplinaId},
        {'id': 2, 'nome': 'Turma B', 'disciplinaId': disciplinaId},
        {'id': 3, 'nome': 'Turma C', 'disciplinaId': disciplinaId},
      ];
      isLoading = false;
    });
  }

  void _onDisciplinaChanged(Map<String, dynamic>? disciplina) {
    setState(() {
      selectedDisciplina = disciplina;
      selectedTurma = null;
      turmas = [];
    });
    if (disciplina != null) {
      _loadTurmas(disciplina['id']);
    }
  }

  void _onTurmaChanged(Map<String, dynamic>? turma) {
    setState(() {
      selectedTurma = turma;
    });
  }

  void _navigateToCorrecao() {
    if (selectedDisciplina != null && selectedTurma != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelecaoAlunoCorrecaoPage(
            disciplina: selectedDisciplina!,
            turma: selectedTurma!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correção de Gabaritos'),
        backgroundColor: theme.primaryColor,
        elevation: 2,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(theme.primaryColor),
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.edit_document,
                size: 48,
                color: theme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Selecione disciplina e turma',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DisciplinaSelector(
                disciplinas: disciplinas,
                selectedDisciplina: selectedDisciplina,
                onChanged: _onDisciplinaChanged,
              ),
              const SizedBox(height: 16),
              if (selectedDisciplina != null)
                TurmaSelector(
                  turmas: turmas,
                  selectedTurma: selectedTurma,
                  onChanged: _onTurmaChanged,
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: (selectedDisciplina != null && selectedTurma != null)
                    ? _navigateToCorrecao
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Continuar para Correção',
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
