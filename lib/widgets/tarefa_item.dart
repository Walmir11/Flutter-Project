import 'package:flutter/material.dart';

import '../models/atividade_estudo.dart';
import 'botao_remover.dart';
import 'texto_padrao.dart';

class TarefaItem extends StatelessWidget {
  final AtividadeEstudo atividade;
  final VoidCallback onAbrirDetalhes;
  final VoidCallback onRemover;

  const TarefaItem({
    super.key,
    required this.atividade,
    required this.onAbrirDetalhes,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onAbrirDetalhes,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Color(0xFF0F766E), width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.school, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextoPadrao(
                        atividade.titulo,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 16,
                            color: colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: TextoPadrao(
                              '${atividade.dataFormatada} às ${atividade.horarioFormatado}',
                              fontSize: 14,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BotaoRemover(onPressed: onRemover),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
