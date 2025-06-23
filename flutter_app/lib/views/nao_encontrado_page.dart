import 'package:flutter/material.dart';

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
              Icons.sentiment_dissatisfied, // Ícone que sugere "não encontrado"
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
                // Voltar para a página anterior, ou para a home se não houver
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacementNamed(
                    '/login',
                  ); // Ou para '/home' se for o caso
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
