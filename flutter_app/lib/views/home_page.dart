import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _provas = [
    {
      'id': '1',
      'disciplina': 'Matemática',
      'titulo': 'Prova P1 - Funções',
      'data': '18/06/2025',
      'cor': const Color(0xFF6366F1),
      'icone': Icons.calculate,
      'alunos': [
        {
          'nome': 'Alice Souza Santos',
          'matricula': '20241010',
          'nota': null,
          'tempo': '45 min',
        },
        {
          'nome': 'Lucas Dias Oliveira',
          'matricula': '20241011',
          'nota': 8.5,
          'tempo': '38 min',
        },
        {
          'nome': 'Mariana Silva Costa',
          'matricula': '20241012',
          'nota': null,
          'tempo': '52 min',
        },
        {
          'nome': 'Rafael Santos Lima',
          'matricula': '20241013',
          'nota': 7.2,
          'tempo': '41 min',
        },
      ],
    },
    {
      'id': '2',
      'disciplina': 'Física',
      'titulo': 'Prova P2 - Termodinâmica',
      'data': '20/06/2025',
      'cor': const Color(0xFF10B981),
      'icone': Icons.science,
      'alunos': [
        {
          'nome': 'Marina Lima Ferreira',
          'matricula': '20241014',
          'nota': null,
          'tempo': '48 min',
        },
        {
          'nome': 'Pedro Martins Silva',
          'matricula': '20241015',
          'nota': null,
          'tempo': '55 min',
        },
        {
          'nome': 'Ana Carolina Rocha',
          'matricula': '20241016',
          'nota': 9.1,
          'tempo': '42 min',
        },
        {
          'nome': 'Bruno Costa Alves',
          'matricula': '20241017',
          'nota': null,
          'tempo': '39 min',
        },
      ],
    },
    {
      'id': '3',
      'disciplina': 'Química',
      'titulo': 'Prova P1 - Química Orgânica',
      'data': '22/06/2025',
      'cor': const Color(0xFFF59E0B),
      'icone': Icons.biotech,
      'alunos': [
        {
          'nome': 'Camila Rodrigues',
          'matricula': '20241018',
          'nota': 8.8,
          'tempo': '44 min',
        },
        {
          'nome': 'Diego Fernandes',
          'matricula': '20241019',
          'nota': null,
          'tempo': '51 min',
        },
        {
          'nome': 'Eduarda Mendes',
          'matricula': '20241020',
          'nota': null,
          'tempo': '47 min',
        },
      ],
    },
  ];

  Map<String, dynamic>? _provaSelecionada;
  String _filtroStatus = 'Todos';
  String? _filtroDisciplina;
  String _termoBusca = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<String> _getDisciplinasDisponiveis() {
    final disciplinas =
        _provas.map((e) => e['disciplina'] as String).toSet().toList();
    disciplinas.sort();
    return disciplinas;
  }

  List<Map<String, dynamic>> _getProvasFiltradas() {
    return _provas.where((prova) {
      final matchDisciplina =
          _filtroDisciplina == null || prova['disciplina'] == _filtroDisciplina;
      final matchBusca =
          _termoBusca.isEmpty ||
          prova['titulo'].toLowerCase().contains(_termoBusca.toLowerCase());
      return matchDisciplina && matchBusca;
    }).toList();
  }

  int _getTotalAlunos() {
    return _provas.fold(
      0,
      (total, prova) => total + (prova['alunos'] as List).length,
    );
  }

  int _getAlunosCorrigidos() {
    int total = 0;
    for (var prova in _provas) {
      final alunos = prova['alunos'] as List;
      total += alunos.where((aluno) => aluno['nota'] != null).length;
    }
    return total;
  }

  List<Map<String, dynamic>> _getAlunosFiltrados() {
    if (_provaSelecionada == null) return [];
    final alunos = _provaSelecionada!['alunos'] as List<Map<String, dynamic>>;
    switch (_filtroStatus) {
      case 'Corrigidos':
        return alunos.where((aluno) => aluno['nota'] != null).toList();
      case 'Pendentes':
        return alunos.where((aluno) => aluno['nota'] == null).toList();
      default:
        return alunos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child:
            _provaSelecionada == null
                ? _buildListaProvas()
                : _buildCorrecaoProva(),
      ),
    );
  }

  Widget _buildListaProvas() {
    final provasFiltradas = _getProvasFiltradas();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: const Color(0xFF1E293B),
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Correção de Provas',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por prova...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _termoBusca = value);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _filtroDisciplina,
                  decoration: InputDecoration(
                    labelText: 'Filtrar por disciplina',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.book),
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todas')),
                    ..._getDisciplinasDisponiveis()
                        .map(
                          (disciplina) => DropdownMenuItem(
                            value: disciplina,
                            child: Text(disciplina),
                          ),
                        )
                        .toList(),
                  ],
                  onChanged: (value) {
                    setState(() => _filtroDisciplina = value);
                  },
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final prova = provasFiltradas[index];
              return ListTile(
                title: Text(prova['titulo']),
                subtitle: Text(prova['disciplina']),
                onTap: () => setState(() => _provaSelecionada = prova),
              );
            }, childCount: provasFiltradas.length),
          ),
        ),
      ],
    );
  }

  Widget _buildCorrecaoProva() {
    final alunos = _getAlunosFiltrados();
    return ListView.builder(
      itemCount: alunos.length,
      itemBuilder: (context, index) {
        final aluno = alunos[index];
        return ListTile(
          title: Text(aluno['nome']),
          subtitle: Text(
            'Matrícula: ${aluno['matricula']} - Tempo: ${aluno['tempo']}',
          ),
        );
      },
    );
  }
}
