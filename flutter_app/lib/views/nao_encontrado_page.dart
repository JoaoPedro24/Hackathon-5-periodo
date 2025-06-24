import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ Importar o go_router

class NaoEncontradoPage extends StatelessWidget {
  const NaoEncontradoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erro 404')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_dissatisfied,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! Página Não Encontrada',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'A rota que você tentou acessar não existe.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Tenta voltar; se não for possível, vai para login
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/login'); // Ou para '/home' se preferir
                }
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
