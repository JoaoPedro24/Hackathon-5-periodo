import 'package:flutter/material.dart';
import 'package:flutter_app/theme_app.dart';
import 'package:flutter_app/viewmodel/login_viewmodel.dart';
import 'package:flutter_app/views/admin_home_page.dart';
import 'package:flutter_app/views/aluno_home_page.dart';
import 'package:flutter_app/views/home_page.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:flutter_app/views/professor_home_page.dart';
import 'package:provider/provider.dart';

import '../views/provas/provas_page.dart';

class MyAppf extends StatelessWidget {
  const MyAppf({super.key});

  // MyAppf é o nome da classe que representa o aplicativo Flutter, que utiliza o pacote MaterialApp para definir o tema, como faziamos no Main.dart
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
      child: MaterialApp(
        title: ('App Flutter x Spring Boot'),
        debugShowCheckedModeBanner: false,
        theme: themeApp(),
        initialRoute: '/login',
        routes: {
          '/login': (_) => LoginPage(),
          '/home': (_) => HomePage(),
          '/adminHome': (context) => AdminHomePage(),
          // <--- ADICIONE ESTA LINHA
          '/professorHome': (context) => ProfessorHomePage(),
          // <--- ADICIONE ESTA LINHA
          '/alunoHome': (context) => AlunoHomePage(),
          '/provas': (context) => ProvasPage(),
        },
      ),
    );
  }
}
