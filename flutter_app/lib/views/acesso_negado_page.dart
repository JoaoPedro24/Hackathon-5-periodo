import 'package:flutter/material.dart';

class AcessoNegadoPage extends StatelessWidget {
  const AcessoNegadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acesso Negado'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Você não tem permissão para acessar essa página.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/professorHome');
              },
              child: const Text('Voltar para área permitida'),
            )
          ],
        ),
      ),
    );
  }
}
