import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/aluno_autocomplete.dart';
import 'package:flutter_app/views/gabarito_correcao_page.dart';

class SelecaoAlunoCorrecaoPage extends StatefulWidget {
  final Map<String, dynamic> disciplina;
  final Map<String, dynamic> turma;

  const SelecaoAlunoCorrecaoPage({
    super.key,
    required this.disciplina,
    required this.turma,
  });

  @override
  State<SelecaoAlunoCorrecaoPage> createState() => _SelecaoAlunoCorrecaoPageState();
}

class _SelecaoAlunoCorrecaoPageState extends State<SelecaoAlunoCorrecaoPage> {
  List<Map<String, dynamic>> alunos = [];
  Map<String, dynamic>? selectedAluno;
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlunos();
  }

  Future<void> _loadAlunos() async {
    setState(() => isLoading = true);
    // Simulação de carregamento de alunos do backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      alunos = [
        {'id': 1, 'codigo': '2024001', 'nome': 'João Silva', 'jaCorrigido': false},
        {'id': 2, 'codigo': '2024002', 'nome': 'Maria Santos', 'jaCorrigido': true},
        {'id': 3, 'codigo': '2024003', 'nome': 'Pedro Oliveira', 'jaCorrigido': false},
        {'id': 4, 'codigo': '2024004', 'nome': 'Ana Costa', 'jaCorrigido': false},
        {'id': 5, 'codigo': '2024005', 'nome': 'Carlos Ferreira', 'jaCorrigido': true},
      ];
      isLoading = false;
    });
  }

  void _onAlunoSelected(Map<String, dynamic>? aluno) {
    if (aluno == null) return;
    if (aluno['jaCorrigido'] == true) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GabaritoCorrecaoPage(
          disciplina: widget.disciplina,
          turma: widget.turma,
          aluno: aluno,
        ),
      ),
    ).then((_) {
      _loadAlunos();
      searchController.clear();
      setState(() {
        selectedAluno = null;
      });
    });
  }

  List<Map<String, dynamic>> _filterAlunos(String query) {
    if (query.isEmpty) return alunos;
    return alunos.where((a) {
      final nome = a['nome'].toString().toLowerCase();
      final codigo = a['codigo'].toString().toLowerCase();
      return nome.contains(query.toLowerCase()) || codigo.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final total = alunos.length;
    final corrigidos = alunos.where((a) => a['jaCorrigido'] == true).length;
    final pendentes = total - corrigidos;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.disciplina['nome']} - ${widget.turma['nome']}'),
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
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Disciplina: ${widget.disciplina['nome']}', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Turma: ${widget.turma['nome']}', style: textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatusChip(label: 'Total', value: '$total', theme: theme),
                        const SizedBox(width: 8),
                        _StatusChip(label: 'Corrigidos', value: '$corrigidos', theme: theme, color: Colors.green),
                        const SizedBox(width: 8),
                        _StatusChip(label: 'Pendentes', value: '$pendentes', theme: theme, color: Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Buscar aluno por nome ou código',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filterAlunos(searchController.text).length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final aluno = _filterAlunos(searchController.text)[index];
                  final jaCorrigido = aluno['jaCorrigido'] == true;
                  return ListTile(
                    title: Text(aluno['nome'], style: textTheme.bodyLarge),
                    subtitle: Text('Código: ${aluno['codigo']}', style: textTheme.bodySmall),
                    trailing: jaCorrigido
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.arrow_forward, color: theme.primaryColor),
                    enabled: !jaCorrigido,
                    onTap: () => _onAlunoSelected(aluno),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Selecione um aluno para iniciar a correção',
                style: textTheme.bodySmall?.copyWith(color: theme.hintColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final Color? color;
  const _StatusChip({required this.label, required this.value, required this.theme, this.color});

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? theme.colorScheme.primary.withOpacity(0.1);
    final fgColor = color != null ? Colors.white : theme.textTheme.bodySmall?.color;
    return Chip(
      label: Text('$label: $value', style: theme.textTheme.bodySmall?.copyWith(color: fgColor)),
      backgroundColor: color ?? bgColor,
    );
  }
}
