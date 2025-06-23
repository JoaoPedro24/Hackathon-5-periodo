import 'package:flutter/material.dart';
import 'package:flutter_app/viewmodel/login_viewmodel.dart';
import 'package:flutter_app/widgets/login_form.dart';
import 'package:flutter_app/widgets/login_header.dart';
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

    // Largura máxima desejada para o “card” de login
    final maxWidth = 400.0;
    // Altura máxima desejada (opcional). Pode ajustar conforme preferir.
    final maxHeight = 600.0;

    return Scaffold(
      // Impede que o Scaffold seja “empurrado” quando o teclado abrir
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              return Center(
                // Se quiser apenas largura fixa: usar SizedBox(width: maxWidth, child: ...)
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // limitar largura para telas grandes
                    maxWidth: maxWidth,
                    // opcional: limitar altura do card de login
                    maxHeight: maxHeight,
                  ),
                  child: Card(
                    // usar Card ou Container com BoxDecoration para destacar o formulário
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: SingleChildScrollView(
                        // permite rolar caso o teclado reduza muito o espaço
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              LoginHeader(textTheme: textTheme),
                              const SizedBox(height: 24),
                              LoginForm(
                                loginController: _loginController,
                                passwordController: _passwordController,
                                obscurePassword: viewModel.obscurePassword,
                                onToggleObscure:
                                    viewModel.toggleObscurePassword,
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
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final user = await viewModel
                                                  .fazerLogin(
                                                    _loginController.text
                                                        .trim(),
                                                    _passwordController.text,
                                                  );
                                              if (user != null) {
                                                final userRole =
                                                    user.role.toUpperCase();
                                                switch (userRole) {

                                                  case 'PROFESSOR':
                                                    Navigator.pushReplacementNamed(
                                                      context,
                                                      '/home',
                                                    );
                                                    break;
                                                  default:
                                                    print(
                                                      'Role desconhecida recebida: ${userRole}',
                                                    );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Erro: Tipo de usuário desconhecido. Contate o suporte.',
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    break;
                                                }
                                              }
                                            }
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.black26,
                                  ),
                                  icon:
                                      viewModel.isLoading
                                          ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
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
