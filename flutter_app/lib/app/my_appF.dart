import 'package:flutter/material.dart';
import 'package:flutter_app/app/utils/app_router.dart';
import 'package:flutter_app/theme_app.dart';
import 'package:flutter_app/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import '../services/aluno_status_service.dart';
import '../viewmodel/prova_viewmodel.dart';
import '../viewmodel/visualizar_alunos_provas_viewmodel.dart';


class MyAppf extends StatelessWidget {
  const MyAppf({super.key});
  // MyAppf é o nome da classe que representa o aplicativo Flutter, que utiliza o pacote MaterialApp para definir o tema, como faziamos no Main.dart
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProvaViewModel()),
        // Provedor para o ViewModel, que agora depende do serviço
        Provider<AlunoStatusService>(create: (_) => AlunoStatusService()),
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
