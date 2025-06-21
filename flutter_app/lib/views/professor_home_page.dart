import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/correcao_gabarito_button.dart';
import 'package:flutter_app/views/selecao_disciplina_turma_page.dart';

class ProfessorHomePage extends StatefulWidget {
  const ProfessorHomePage({super.key});

  @override
  State<ProfessorHomePage> createState() => _ProfessorHomePageState();
}

class _ProfessorHomePageState extends State<ProfessorHomePage> {
  void _navigateToCorrecaoGabarito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelecaoDisciplinaTurmaPage(),
      ),
    );
  }

  final List<_MenuItem> _menuItems = [
    _MenuItem(
      icon: Icons.assignment,
      title: 'Gerenciar Provas',
      subtitle: 'Criar e editar provas',
      onTap: () {

      },
    ),
    _MenuItem(
      icon: Icons.people,
      title: 'Gerenciar Turmas',
      subtitle: 'Visualizar e editar turmas',
      onTap: () {

      },
    ),
    _MenuItem(
      icon: Icons.analytics,
      title: 'Relatórios',
      subtitle: 'Visualizar estatísticas e relatórios',
      onTap: () {

      },
    ),
    // Adicionar mais itens conforme necessidade
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Professor'),
        backgroundColor: theme.primaryColor,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.primaryColorLight,
                child: Icon(
                  Icons.school,
                  size: 40,
                  color: theme.primaryColorDark,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bem-vindo, Professor!',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CorrecaoGabaritoButton(
                  onPressed: _navigateToCorrecaoGabarito,
                ),
              ),
              const SizedBox(height: 32),
              // Menu items grid/list
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _menuItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: Icon(
                          item.icon,
                          color: theme.primaryColor,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: textTheme.bodyMedium,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.hintColor,
                      ),
                      onTap: item.onTap,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: const Icon(Icons.add),
        tooltip: 'Adicionar novo',
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
