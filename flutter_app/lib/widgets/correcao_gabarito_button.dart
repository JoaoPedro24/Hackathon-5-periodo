import 'package:flutter/material.dart';

class CorrecaoGabaritoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CorrecaoGabaritoButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.assignment_turned_in),
        label: const Text('Corrigir Gabaritos'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

