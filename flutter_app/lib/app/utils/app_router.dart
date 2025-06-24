import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/views/home_page.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:flutter_app/views/nao_encontrado_page.dart';
import 'package:flutter_app/views/visualizar_alunos_provas.dart';
import 'package:flutter_app/auth/widgets/auth_guard.dart';
import 'package:flutter_app/views/acesso_negado_page.dart';

final GoRouter appRouter = GoRouter(
  // rota inicial do aplicativo
  initialLocation: '/login',
  // Lista de todas as rotas do app
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(
      path: '/home',
      builder:
          (context, state) => const AuthGuard(
            protectedPage: HomePage(),
            allowedRoles: ['PROFESSOR'],
          ),
    ),
    GoRoute(
      // ':provaId' indica que essa parte da rota é um parâmetro
      path: '/visualizar/:provaId',
      builder: (context, state) {
        final String? provaIdString = state.pathParameters['provaId'];
        final int? provaId = int.tryParse(provaIdString ?? '');

        if (provaId == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Erro de Rota')),
            body: Center(child: Text('ID da prova inválido ou não fornecido.')),
          );
        }
        return AuthGuard(
          protectedPage: VisualizarProvas(provaId: provaId),
          allowedRoles: const ['PROFESSOR'],
        );
      },
    ),
    GoRoute(
      path: '/acessoNegado',
      builder: (context, state) => const AcessoNegadoPage(),
    ),
  ],
  errorBuilder: (context, state) => const NaoEncontradoPage(),
);
