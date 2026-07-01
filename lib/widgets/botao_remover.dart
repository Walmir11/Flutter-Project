import 'package:flutter/material.dart';

class BotaoRemover extends StatelessWidget {
  final VoidCallback onPressed;

  const BotaoRemover({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Remover atividade',
      onPressed: onPressed,
      icon: const Icon(Icons.delete),
      color: Colors.red,
    );
  }
}
