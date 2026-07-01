import 'package:flutter/material.dart';

import '../models/atividade_estudo.dart';
import 'botao_remover.dart';
import 'texto_padrao.dart';

class TarefaItem extends StatelessWidget {
  final AtividadeEstudo atividade;
  final VoidCallback onEditar;
  final VoidCallback onAbrirDetalhes;
  final VoidCallback onRemover;
  final VoidCallback? onConcluir;

  const TarefaItem({
    super.key,
    required this.atividade,
    required this.onEditar,
    required this.onAbrirDetalhes,
    required this.onRemover,
    this.onConcluir,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = atividade.concluida
        ? const Color(0xFF16A34A)
        : const Color(0xFF0F766E);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onEditar,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: borderColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: atividade.concluida
                        ? const Color(0xFFE7F5EC)
                        : colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    atividade.concluida ? Icons.check_circle : Icons.school,
                    color: atividade.concluida
                        ? const Color(0xFF16A34A)
                        : colorScheme.primary,
                  ),
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
                IconButton(
                  tooltip: 'Ver detalhes',
                  onPressed: onAbrirDetalhes,
                  icon: const Icon(Icons.info_outline),
                  color: colorScheme.primary,
                ),
                if (onConcluir != null)
                  IconButton(
                    tooltip: 'Concluir atividade',
                    onPressed: onConcluir,
                    icon: const Icon(Icons.check_circle_outline),
                    color: const Color(0xFF16A34A),
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
