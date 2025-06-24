import 'package:flutter/material.dart';
import 'package:flutter_app/app/utils/app_router.dart';
import 'package:flutter_app/theme_app.dart';
import 'package:flutter_app/viewmodel/login_viewmodel.dart';
import 'package:flutter_app/views/home_page.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:flutter_app/views/nao_encontrado_page.dart';
import 'package:flutter_app/views/visualizar_alunos_provas.dart';
import 'package:provider/provider.dart';
import '../auth/widgets/auth_guard.dart';
import '../services/aluno_status_service.dart';
import '../viewmodel/prova_viewmodel.dart';
import '../viewmodel/visualizar_alunos_provas_viewmodel.dart';
import '../views/acesso_negado_page.dart';

class MyAppf extends StatelessWidget {
  const MyAppf({super.key});

  // MyAppf é o nome da classe que representa o aplicativo Flutter, que utiliza o pacote MaterialApp para definir o tema, como faziamos no Main.dart
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProvaViewModel()),
        Provider<AlunoStatusService>(create: (_) => AlunoStatusService()),
        // Provedor para o ViewModel, que agora depende do serviço
        ChangeNotifierProvider(
          create:
              (context) => VisualizarAlunosProvasViewmodel(
                Provider.of<AlunoStatusService>(context, listen: false),
              ),
        ),
      ],
      child: MaterialApp.router(
        title: ('App Flutter x Spring Boot Hackathon'),
        debugShowCheckedModeBanner: false,
        theme: themeApp(),
        routerConfig: appRouter,
      ),
    );
  }
}
