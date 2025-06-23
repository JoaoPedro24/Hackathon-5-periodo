import 'package:flutter/material.dart';
import 'package:flutter_app/theme_app.dart';
import 'package:flutter_app/viewmodel/login_viewmodel.dart';
import 'package:flutter_app/views/home_page.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:flutter_app/views/nao_encontrado_page.dart';
import 'package:provider/provider.dart';
import '../auth/widgets/auth_guard.dart';
import '../viewmodel/prova_viewmodel.dart';
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
      ],

      child: MaterialApp(
        title: ('App Flutter x Spring Boot'),
        debugShowCheckedModeBanner: false,
        theme: themeApp(),
        initialRoute: '/login',
        routes: {
          '/login': (_) => LoginPage(),

          '/home':
              (_) => const AuthGuard(
                protectedPage: HomePage(),
                allowedRoles: ['PROFESSOR'],
              ),
          '/acessoNegado': (_) => const AcessoNegadoPage(),
        },
        // --- AQUI É ONDE VOCÊ TRATA O 404 ---
        onGenerateRoute: (RouteSettings settings) {
          // Esta função é chamada para qualquer rota que não esteja definida no 'routes' acima.
          // Você pode inspecionar settings.name para ver qual rota foi solicitada.

          // Neste caso, se a rota não for encontrada nas rotas pré-definidas,
          // simplesmente retorne a sua PageNotFoundPage.
          return MaterialPageRoute(builder: (_) => const NaoEncontradoPage());
        },
      ),
    );
  }
}
