import 'package:flutter/material.dart';
import 'package:flutter_app/viewmodel/login_viewmodel.dart';
import 'package:flutter_app/views/widgets/login_form.dart';
import 'package:flutter_app/views/widgets/login_header.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2FF), Color(0xFFCBD5E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          LoginHeader(textTheme: textTheme),
                          const SizedBox(height: 40),
                          LoginForm(
                            loginController: _loginController,
                            passwordController: _passwordController,
                            obscurePassword: viewModel.obscurePassword,
                            onToggleObscure: viewModel.toggleObscurePassword,
                          ),
                          const SizedBox(height: 32),
                          if (viewModel.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                viewModel.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed:
                                  viewModel.isLoading
                                      ? null
                                      : () async {
                                        if (_formKey.currentState!.validate()) {
                                          final user = await viewModel.fazerLogin(
                                            _loginController.text
                                                .trim(), // ou usernameController, se ainda não renomeou
                                            _passwordController.text,
                                          );

                                          if (user != null) {
                                            switch (user.perfil) {
                                              case 'ADMIN':
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  '/adminHome',
                                                );
                                                break;
                                              case 'PROFESSOR':
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  '/professorHome',
                                                );
                                                break;
                                              default:
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  '/alunoHome',
                                                );
                                            }
                                          }
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black26,
                              ),
                              icon:
                                  viewModel.isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Icon(Icons.login),
                              label: const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
