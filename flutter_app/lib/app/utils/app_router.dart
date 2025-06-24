// lib/utils/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/views/home_page.dart'; // Importa a página Home
import 'package:flutter_app/views/login_page.dart'; // Importa a página de Login
import 'package:flutter_app/views/nao_encontrado_page.dart'; // Importa a página Não Encontrado
import 'package:flutter_app/views/visualizar_alunos_provas.dart'; // Importa sua tela de Visualizar Provas
import 'package:flutter_app/auth/widgets/auth_guard.dart'; // Importa o seu AuthGuard
import 'package:flutter_app/views/acesso_negado_page.dart'; // Importa a página de Acesso Negado


// Instância global do GoRouter para ser usada em MaterialApp.router
final GoRouter appRouter = GoRouter(
  // Define a rota inicial do seu aplicativo
  initialLocation: '/login',

  // Lista de todas as rotas da sua aplicação
  routes: [
    GoRoute(
      // Rota para a página de login
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      // Rota para a página inicial (Home)
      path: '/home',
      builder: (context, state) => const AuthGuard(
        protectedPage: HomePage(),
        allowedRoles: ['PROFESSOR'], // Define as roles permitidas
      ),
    ),
    GoRoute(
      // Rota para visualizar provas com um ID dinâmico
      // O ':provaId' indica que essa parte da rota é um parâmetro
      path: '/visualizar/:provaId',
      builder: (context, state) {
        // Extrai o 'provaId' dos parâmetros de caminho da URL
        final String? provaIdString = state.pathParameters['provaId'];
        // Tenta converter a string do ID para um inteiro
        final int? provaId = int.tryParse(provaIdString ?? '');

        // Validação básica: se o ID não for um número válido, mostra uma tela de erro
        if (provaId == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Erro de Rota')),
            body: Center(child: Text('ID da prova inválido ou não fornecido.')),
          );
        }

        // Retorna a página de visualização de provas, protegida pelo AuthGuard
        return AuthGuard(
          protectedPage: VisualizarProvas(provaId: provaId),
          allowedRoles: const ['PROFESSOR'], // Define as roles permitidas para esta rota
        );
      },
    ),
    GoRoute(
      // Rota para a página de acesso negado
      path: '/acessoNegado',
      builder: (context, state) => const AcessoNegadoPage(),
    ),
  ],

  // Gerenciador de rotas de erro:
  // Chamado quando uma rota não é encontrada, substituindo o 'onGenerateRoute' do MaterialApp
  errorBuilder: (context, state) => const NaoEncontradoPage(),
);
