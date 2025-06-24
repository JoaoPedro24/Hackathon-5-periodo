import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AuthGuard extends StatelessWidget {
  final Widget protectedPage;
  final List<String>? allowedRoles;

  const AuthGuard({super.key, required this.protectedPage, this.allowedRoles});

  Future<_AuthStatus> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('usuario_role')?.toUpperCase();

    if (token == null || token.isEmpty) {
      return _AuthStatus.notLoggedIn;
    }

    if (allowedRoles == null || allowedRoles!.isEmpty) {
      return _AuthStatus.authorized;
    }

    if (role == 'ADMIN' || allowedRoles!.contains(role)) {
      return _AuthStatus.authorized;
    }
    return _AuthStatus.notAuthorized;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AuthStatus>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final status = snapshot.data!;
        if (status == _AuthStatus.authorized) {
          return protectedPage;
        } else if (status == _AuthStatus.notLoggedIn) {
          Future.microtask(() => context.go('/login'));
          return const Scaffold(
            body: Center(child: Text('Redirecionando para login...')),
          );
        } else {
          Future.microtask(() => context.go('/acessoNegado'));
          return const Scaffold(body: Center(child: Text('Acesso negado.')));
        }
      },
    );
  }
}

enum _AuthStatus { authorized, notLoggedIn, notAuthorized }
