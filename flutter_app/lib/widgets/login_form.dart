import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController loginController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;

  const LoginForm({
    super.key,
    required this.loginController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: loginController, // antes era usernameController
          decoration: const InputDecoration(
            labelText: 'Login',
            hintText: 'Digite seu login',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite seu login';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Senha',
            hintText: 'Digite sua senha',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onToggleObscure,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite sua senha';
            }
            return null;
          },
        ),
      ],
    );
  }
}
