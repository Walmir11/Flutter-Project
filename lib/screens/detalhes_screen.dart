import 'package:flutter/material.dart';

import '../models/atividade_estudo.dart';
import '../widgets/texto_padrao.dart';

class DetalhesScreen extends StatelessWidget {
  final AtividadeEstudo atividade;

  const DetalhesScreen({super.key, required this.atividade});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da atividade')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.auto_stories,
                          color: colorScheme.secondary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextoPadrao(
                        atividade.titulo,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 22),
                      _LinhaDetalhe(
                        icon: Icons.calendar_month,
                        titulo: 'Data',
                        valor: atividade.dataFormatada,
                      ),
                      const SizedBox(height: 14),
                      _LinhaDetalhe(
                        icon: Icons.schedule,
                        titulo: 'Hora',
                        valor: atividade.horarioFormatado,
                      ),
                      if (atividade.descricao.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _LinhaDetalhe(
                          icon: Icons.notes,
                          titulo: 'Descrição',
                          valor: atividade.descricao,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.tertiary.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: TextoPadrao(
                        'Organize seu horário de estudo com antecedência.',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinhaDetalhe extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;

  const _LinhaDetalhe({
    required this.icon,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextoPadrao(
                titulo,
                fontSize: 13,
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
              TextoPadrao(valor, fontSize: 16, fontWeight: FontWeight.w600),
            ],
          ),
        ),
      ],
    );
  }
}
